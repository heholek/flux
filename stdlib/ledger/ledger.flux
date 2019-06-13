package ledger

import "strings"

// From reads a ledger (hledger) file and produces a single table with each posting as a row.
builtin from

assets = (tables=<-) =>
    tables
        |> filter(fn: (r) => strings.toLower(v:r.l0) == "assets")

liabilities = (tables=<-) =>
    tables
        |> filter(fn: (r) => strings.toLower(v:r.l0) == "liabilities")

expenses = (tables=<-) =>
    tables
        |> filter(fn: (r) => strings.toLower(v:r.l0) == "expenses")

income = (tables=<-) =>
    tables
        |> filter(fn: (r) => strings.toLower(v:r.l0) == "income")

balancesheet = (tables=<-) => {
        liabilities = tables |> liabilities() |> group(columns:["_stop", "commodity"]) |> sum()
        assets = tables |> assets() |> group(columns:["_stop", "commodity"]) |> sum()
        return join(tables:{assets, liabilities}, on:["_stop", "commodity"])
    }