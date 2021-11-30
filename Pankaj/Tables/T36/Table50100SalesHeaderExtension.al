tableextension 50100 SalesHeaderExt extends "Sales Header"
{
    fields
    {
        Field(50000; "Lost Opportunity"; Boolean) { }
        Field(50001; "Lost Opportunity Description"; Text[50]) { }
        Field(50002; "Lock Price"; Boolean) { }
        Field(50005; "Lot Price"; Boolean) { }
        Field(50006; "Back Order"; Boolean) { }
        Field(50010; "Document Needs Approval"; Boolean) { }
        Field(50011; "Layout No."; Code[30]) { }
        Field(50020; "Consolidated Order"; Boolean) { }
        Field(50029; "No. of Lost Opporunity Lines"; Integer) { }
        Field(50030; "Non Divisional"; Boolean) { }
        Field(50035; "RSM Code"; Code[10]) { }
        Field(50050; "E-Mail (ASN)"; Text[80]) { }
        Field(50095; "Hard Copy PO Available"; Boolean) { }
        Field(50096; "Quote Version No."; Integer) { }
        Field(50097; "Customer Comments"; Text[80]) { }
        Field(50098; "Finance Comments"; Text[80]) { }
        Field(50099; "Shipping Comments"; Text[80]) { }
        Field(50100; "Mfr. Rep. Code"; Code[20]) { }
        Field(50101; "ISR Code"; Code[10]) { }
        Field(50102; "CSR Code"; Code[10]) { }
        Field(50103; "Job Name"; Code[30]) { }
        Field(50104; "Free Freight Override"; Boolean) { }
        //Field(50105;"Free Freight Override Reason;Option[]){}
        Field(50107; "E-Mail Invoice Notice Handled"; Boolean) { }
        Field(50200; "Shortcut Dimension 5 Code"; Code[20]) { }
        Field(51006; Mail; Boolean) { }
        Field(51007; Fax; Boolean) { }
        Field(51016; "Price Adjustment"; Boolean) { }
        Field(51029; "Warehouse Release No."; Code[20]) { }
        Field(51056; "Return to Warehouse"; Boolean) { }
        Field(51077; "Internal Comment"; Text[30]) { }
        Field(51409; "Free Freight Reason Code"; Code[10]) { }
        //Field(51477;Warehouse Request Status;Option[]){}
        Field(51480; "Ship-to Phone No."; Text[30]) { }
        Field(51700; "Mfr. Rep. Comm. %"; Decimal) { }
        Field(51701; "Mfr. Rep. Comm. Amount"; Decimal) { }
        Field(51702; "Location Hdlg. %"; Decimal) { }
        Field(51703; "Location Hdlg. Amount"; Decimal) { }
        Field(60000; "945 Processed"; Boolean) { }
        Field(60010; "940 Required"; Boolean) { }
        Field(60020; "Topaz WH Billing"; Boolean) { }
        Field(60030; "TPZ WH TP No."; Code[20]) { }
        Field(65000; "Master Order No."; Code[20]) { }
        Field(65010; "Original Free Freight Base"; Decimal) { }
        Field(65015; "Delivery Date"; Date) { }
        Field(70551; "Exclude from Usage"; Boolean) { }
        Field(70552; "XML Order"; Boolean) { }
        Field(70553; IspickupOrder; Boolean) { }
        field(14000717; "Third Party Ship. Account No."; Code[20]) { }
        field(14000716; "Shipping Payment Type"; Enum SalesEnum) { }
        //Field(11123321;"Webshop Document State";Option[]){}
        Field(11123399; "Unique Webshop Document Id"; GUID) { }
        Field(14000350; "EDI Order"; Boolean) { }
        Field(14000351; "EDI Internal Doc. No."; Code[10]) { }
        Field(14000354; "EDI Ack. Generated"; Boolean) { }
        Field(14000355; "EDI Ack. Gen. Date"; date) { }
        Field(14000360; "EDI Released"; Boolean) { }
        Field(14000361; "EDI WHSE Shp. Gen"; Boolean) { }
        Field(14000362; "EDI WHSE Shp. Gen Date"; date) { }
        Field(14000365; "EDI Expected Delivery Date"; date) { }
        Field(14000366; "EDI Trade Partner"; Code[20]) { }
        Field(14000367; "EDI Sell-to Code"; Code[20]) { }
        Field(14000368; "EDI Ship-to Code"; Code[20]) { }
        Field(14000369; "EDI Ship-for Code"; Code[20]) { }
        Field(14000370; "Order Status Required"; Boolean) { }
        Field(14000371; "Pricing Discrepancy"; Boolean) { }
        Field(14000372; "EDI Cancel After Date"; date) { }
        Field(14000373; "Shipment Release"; Boolean) { }
        Field(14000374; "EDI Invoice"; Boolean) { }
        Field(14000375; "EDI Cancellation Request"; Boolean) { }
        Field(14000376; "EDI Cancellation Date"; date) { }
        Field(14000379; "EDI Cancellation Advice"; Boolean) { }
        Field(14000380; "EDI Cancellation Advice Date"; date) { }
        Field(14000381; "EDI Cancellation Generated"; Boolean) { }
        Field(14000382; "EDI Transaction Date"; date) { }
        Field(14000383; "EDI Transaction Time"; Time) { }
        Field(14000391; "EDI Response to Request Req."; Boolean) { }
        Field(14000392; "EDI Response Generated"; Boolean) { }
        Field(14000393; "EDI Response Generated Date"; date) { }
        Field(14000394; "EDI Quote Change Request"; Boolean) { }
        Field(14000395; "EDI Quote Change Processed"; Boolean) { }
        Field(14000396; "EDI Quote Change ProcessedDate"; date) { }
        Field(14000601; "Total Qty. Received (base)"; decimal) { }
        Field(14000602; "Total Outstanding Qty. (base)"; decimal) { }
        Field(14000603; "Total Return Qty to Rec (base)"; decimal) { }
        Field(14000604; "Receive Exists"; Boolean) { }
        Field(14000701; "E-Ship Agent Service"; Code[30]) { }
        Field(14000702; "Total Qty. To Ship (base)"; decimal) { }
        Field(14000703; "Total Qty. Packed (base)"; decimal) { }
        Field(14000704; "Residential Delivery"; Boolean) { }
        Field(14000705; "Free Freight"; Boolean) { }
        Field(14000706; "COD Payment"; Boolean) { }
        Field(14000709; "World Wide Service"; Boolean) { }
        Field(14000710; "Blind Shipment"; Boolean) { }
        Field(14000711; "Double Blind Shipment"; Boolean) { }
        Field(14000712; "Double Blind Ship-from Cust No"; Code[20]) { }
        Field(14000713; "No Free Freight Lines on Order"; Boolean) { }
        Field(14000714; "COD Cashiers Check"; Boolean) { }
        Field(14000715; "E-Ship Whse. Outst. Qty (Base)"; decimal) { }
        //Field(14000716;"Shipping Payment Type";Option[]){}
        //Field(14000717;"Third Party Ship. Account No.";Code[20]){}
        //Field(14000718;"Shipping Insurance";Option[]){}
        Field(14000719; "E-Ship Whse. Ship. Qty (Base)"; decimal) { }
        Field(14000720; "E-Ship Invt. Outst. Qty (Base)"; decimal) { }
        Field(14000722; "E-Ship Outst. Lines Exists"; Boolean) { }
        Field(14000723; "Exists on Bill of Lading"; Boolean) { }
        Field(14000724; "Package Exists"; Boolean) { }
        Field(14000725; "Warehouse Shipment Exists"; Boolean) { }
        Field(14000726; "Inventory Pick Exists"; Boolean) { }
        Field(14000825; "Ship-for Code"; Code[20]) { }
        Field(14000826; "External Sell-to No."; Code[20]) { }
        Field(14000827; "External Ship-to No."; Code[20]) { }
        Field(14000828; "External Ship-for No."; Code[20]) { }
        Field(14000829; "Invoice for Bill of Lading No."; Code[20]) { }
        Field(14000831; "Invoice for Shipment No."; Code[20]) { }
        Field(14000832; "Shipment Invoice Override"; Boolean) { }
        Field(14000901; "E-Mail Confirmation Handled"; Boolean) { }
        Field(14002399; "Run From EDI"; Boolean) { }

    }
}