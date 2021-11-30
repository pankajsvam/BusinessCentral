tableextension 50104 LocationExt extends Location
{
    fields
    {
        Field(50000; "Default Purchasing Code"; Code[10]) { }
        Field(50001; "Enable E-Receive"; Boolean) { }
        Field(50002; "Enable DMS"; Boolean) { }
        Field(50003; "Incoming Inspection Bin Code"; Code[20]) { }
        Field(50010; "Post from Whse. with Job Q."; Boolean) { }
        Field(50011; "Job Q. Prio. for P. from Whse."; Integer) { }
        Field(50012; "Post from Whse. Start Time"; Time) { }
        Field(50013; "Bulk Pick Ranking (>=)"; Integer) { }
        Field(50014; "Buld Pick Ranking Source Doc."; Integer) { }
        Field(50020; "Auto Pick"; Boolean) { }
        Field(50021; "Phys. Inv. Journal Batch"; Code[10]) { }
        Field(50022; "Whse. Phys. Inv. Jnl. Batch"; Code[10]) { }
        Field(50023; "Whse. Phys. Inv. Jnl. Batch To"; Code[10]) { }
        Field(50025; "Whse. Item Jnl. Batch"; Code[10]) { }
        Field(50026; "Auto LP Generate"; Boolean) { }
        Field(50027; "Auto LP Less Than Lines"; Integer) { }
        Field(50030; "Pick Complete Quantity"; Boolean) { }
        Field(50031; "Enable Bin Ranking for Picks"; Boolean) { }
        Field(50032; "Print Address Label"; Boolean) { }
        Field(50130; "Shipping Location"; Boolean) { }
        Field(50142; "Distribution Center"; Boolean) { }
        Field(50143; "Distribution Center Code"; Code[10]) { }
        Field(50145; "Non Inventory Location"; Boolean) { }
        Field(51098; "Blocked"; Boolean) { }
        Field(51402; "Type"; Enum Location_Type) { }
        Field(51445; "No. of Months for Avg. Usage"; Integer) { }
        Field(51446; "No. of Ms. to Purch./Transfer"; Integer) { }
        Field(51490; "Label ID"; Code[10]) { }
        Field(51702; "Pay-to Vendor No."; Code[20]) { }
        Field(51704; "Send Source Documents"; Boolean) { }
        Field(51705; "Backup Location Code"; Code[10]) { }
        Field(70551; "Carrying Cost %"; Decimal) { }
        Field(70552; "Ordering Cost"; Decimal) { }
        Field(70553; "Last Day-End Date"; Date) { }
        Field(70554; "System Date of Last Day-End"; Date) { }
        Field(70555; "Last Closed Period Date"; Date) { }
        Field(70556; "Select Day End Processing"; Code[60]) { }
        Field(70557; "Select Period End Processing"; Code[60]) { }
        Field(70558; "Stocking Rule Code"; Code[10]) { }
        Field(70568; "Last Item Rcpt. Entry No."; Integer) { }
        Field(70569; "Re-Close Last Closed Period"; Boolean) { }
        Field(70570; "Enable Adv. Forecasting"; Boolean) { }
        Field(70571; "Enable Cust. Forecasting"; Boolean) { }
        Field(70572; "Def. Repl. Source Type"; enum LocationDefReplSourceType) { }
        Field(70573; "Def. Repl. Source Code"; Code[20]) { }
        Field(70574; "Def. Nonstock Unit"; Boolean) { }
        Field(70575; "Def. Include Drop Ship Usage"; Boolean) { }
        Field(70576; "Adjusted Period Alert"; Boolean) { }
        Field(70577; "Auto Process Day End"; Boolean) { }
        Field(70578; "Auto Process Period End"; Boolean) { }
        Field(70579; "Enable Moving Average"; Boolean) { }
        Field(70581; "Reforecast Required Units"; Integer) { }
        Field(70582; "Variant Summarize Pending"; Integer) { }
        Field(70583; "Redirect From Pending"; Integer) { }
        Field(70584; "Redirect To Pending"; Integer) { }
        Field(70585; "Redirect Delete Pending"; Integer) { }
        Field(70586; "Def. Safety Stock Calc. Method"; enum LocationDefSafetyStockCalcMeth) { }
        Field(70587; "Def. Target Cust. Service Lvl."; Code[10]) { }
        Field(70588; "Auto Process Prod. Plan"; Boolean) { }
        Field(70589; "AFP Prod. Planning Name"; Code[10]) { }
        Field(70590; "AFP Prod. Template Name"; Code[10]) { }
        Field(70591; "Last Prod. Plan Date"; Date) { }
        Field(70592; "Maintain Sporadic Stock Qty."; Boolean) { }
        Field(70593; "Roll Up Order Quantity Rule"; enum LocationRollUpOrdeQuantityRule) { }
        Field(70594; "Last Prod. Order Review"; Date) { }
        Field(70595; "Reforecast Items"; Integer) { }
        Field(70596; "Prod. Plan Locked Through"; Date) { }
        Field(70597; "Enable AFP Production"; Boolean) { }
        Field(70598; "Vend. Surplus Calc. Add Days"; Decimal) { }
        Field(70599; "Vend. Surplus Calc. Add Pct."; Decimal) { }
        Field(70600; "Loc. Surplus Calc. Add Days"; Decimal) { }
        Field(70601; "Loc. Surplus Calc. Add Pct."; Decimal) { }
        Field(70602; "Def. Minimum Days"; Decimal) { }
        Field(70603; "Def. Maximum Days"; Decimal) { }
        Field(70604; "Min. Presentation Qty."; Decimal) { }
        Field(70605; "Auto. Forecast Adj. %"; Decimal) { }
        Field(70606; "Sporadic Rule"; Code[10]) { }
        Field(70607; "Include Service Usage"; Boolean) { }
        Field(70609; "Location Planning Sequence"; Integer) { }
        Field(70610; "Enable Assembly Forecast"; Boolean) { }
        Field(70611; "Sporadic Spoke Hub Lead Time"; Boolean) { }
    }
}