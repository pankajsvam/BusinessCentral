tableextension 50101 SalesLineExt extends "Sales Line"
{
    fields
    {
        Field(50001; "Lost Opportunity Description"; Text[50]) { }
        Field(50007; "Last Unit Price"; Decimal) { }
        Field(50008; "Last Price UOM"; Code[10]) { }
        Field(50009; "Last Price Qty."; Decimal) { }
        Field(50010; "Unit Price Color"; Code[15]) { }
        Field(50011; "Return Reason Desc"; Text[50]) { }
        Field(50012; "QA Sub Reason Code"; Code[10]) { }
        Field(50013; "Last Price Date"; Date) { }
        //Field(50014;"Pricing Logic";Option[]){}
        Field(50026; "Lost Opportunity"; Boolean) { }
        Field(50027; "Reason Code"; Code[10]) { }
        Field(50028; "Reason Code Comment"; Text[60]) { }
        Field(50029; "Hot Sheet Code"; Code[10]) { }
        Field(50030; "Special Price"; Boolean) { }
        Field(50051; "Sample"; Boolean) { }
        Field(50100; "Mfr. Rep. Code"; Code[20]) { }
        Field(50101; "ISR Code"; Code[10]) { }
        Field(50102; "CSR Code"; Code[10]) { }
        Field(50103; "Comment"; Boolean) { }
        Field(50200; "Shortcut Dimension 5 Code"; Code[20]) { }
        Field(50201; "Multiplier"; Decimal) { }
        Field(50202; "Recomm. Unit Price"; Decimal) { }
        Field(50203; "Actual Unit Price"; Decimal) { }
        Field(50204; "Alt. UOM Recomm. Unit Price"; Decimal) { }
        Field(50205; "Alt. UOM Actual Unit Price"; Decimal) { }
        Field(50206; "Recomm. Multiplier"; Decimal) { }
        Field(50300; "Average Unit Cost"; Decimal) { }
        Field(50301; "Gross Margin % Avg Cost"; Decimal) { }
        Field(50302; "Average Unit Cost Per Loc"; Decimal) { }
        Field(50303; "Replacement Cost"; Decimal) { }
        Field(50304; "Replacement Margin"; Decimal) { }
        Field(50329; "Item Blocked"; Boolean) { }
        Field(50390; "Item Blocked Reason Code"; Code[10]) { }
        Field(50500; "Alt. UOM Code"; Code[10]) { }
        Field(50501; "Alt. Unit of Measure"; Text[10]) { }
        Field(50502; "Alt. UOM Quantity"; Decimal) { }
        Field(50503; "Alt. UOM Unit Price"; Decimal) { }
        Field(50504; "Qty. per Alt. UOM"; Decimal) { }
        Field(51017; "Old Actual Unit Price"; Decimal) { }
        Field(51018; "New Actual Unit Price"; Decimal) { }
        Field(51019; "Requested Unit Price"; Decimal) { }
        Field(51082; "Quote No."; Code[20]) { }
        Field(51084; "Quote Line No."; Integer) { }
        Field(51086; "Qty. to Order"; Decimal) { }
        Field(51087; "Qty. Ordered"; Decimal) { }
        Field(51088; "Qte. Qty. Shipped"; Decimal) { }
        Field(51089; "Qte. Qty. Invoiced"; Decimal) { }
        Field(51091; "External Document Line No."; Code[10]) { }
        Field(51434; "Vendor Item No."; Text[20]) { }
        Field(51700; "Mfr. Rep. Comm. %"; Decimal) { }
        Field(51701; "Mfr. Rep. Comm. Amount"; Decimal) { }
        Field(51702; "Location Hdlg. %"; Decimal) { }
        Field(51703; "Location Hdlg. Amount"; Decimal) { }
        Field(51704; "Commission Payable"; Boolean) { }
        Field(55000; "Base UOM Price"; Decimal) { }
        Field(55040; "Modified UserID"; Code[20]) { }
        Field(55041; "Promo"; Boolean) { }
        Field(55043; "Sales Price Mult. Factor"; Decimal) { }
        Field(55044; "Pre Price inc."; Decimal) { }
        Field(55045; "Post Price Inc."; Decimal) { }
        Field(55046; "Stock Status Unit Price"; Decimal) { }
        Field(69000; "Temp Sales Order No."; Code[20]) { }
        Field(70554; "Exclude from Usage"; Boolean) { }
        Field(70558; "Demand Date"; Date) { }
        Field(70562; "Ship-to Code"; Code[10]) { }
        Field(70700; "Sales Price Bill To"; Code[20]) { }

    }
}