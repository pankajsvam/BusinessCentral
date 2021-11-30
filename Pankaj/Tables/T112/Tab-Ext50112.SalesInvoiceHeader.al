tableextension 50112 SalesInvoiceHeader extends "sales invoice header"
{
    fields
    {
        Field(50001; "Lost Opportunity Description"; Text[50]) { }
        Field(50005; "Lot Price"; Boolean) { }
        Field(50011; "Layout No."; Code[30]) { }
        Field(50030; "Non Divisional"; Boolean) { }
        Field(50035; "RSM Code"; Code[10]) { }
        Field(50050; "E-Mail (ASN)"; Text[80]) { }
        Field(50095; "Hard Copy PO Available"; Boolean) { }
        Field(50096; "Quote Version No."; Integer) { }
        Field(50097; "Customer Comments"; Text[100]) { }
        Field(50098; "Finance Comments"; Text[100]) { }
        Field(50099; "Shipping Comments"; Text[100]) { }
        Field(50100; "Mfr. Rep. Code"; Code[20]) { }
        Field(50101; "ISR Code"; Code[10]) { }
        Field(50102; "CSR Code"; Code[10]) { }
        Field(50103; "Job Name"; Code[30]) { }
        Field(50108; "SignatureImage"; blob) { }
        Field(50109; "No. Of Cartons"; Integer) { }
        Field(50110; "Full Name"; Text[50]) { }
        Field(50111; "Check No."; Integer) { }
        Field(50112; "Check Amount"; Decimal) { }
        Field(50113; "Signature Date"; Date) { }
        Field(50200; "Shortcut Dimension 5 Code"; Code[20]) { }
        Field(51006; "Mail"; Boolean) { }
        Field(51007; "Fax"; Boolean) { }
        Field(51008; "Mail Invoice Notice Handled"; Boolean) { }
        Field(51009; "Fax Invoice Notice Handled"; Boolean) { }
        Field(51029; "Warehouse Release No."; Code[20]) { }
        Field(51409; "Free Freight Reason Code"; Code[10]) { }
        Field(51480; "Ship-to Phone No."; Text[30]) { }
        Field(51700; "Mfr. Rep. Comm. %"; Decimal) { }
        Field(51701; "Mfr. Rep. Comm. Amount"; Decimal) { }
        Field(51702; "Location Hdlg. %"; Decimal) { }
        Field(51703; "Location Hdlg. Amount"; Decimal) { }
        Field(51704; "Use Mfr. Rep. Comm. Amount"; Decimal) { }
        Field(51709; "Item Amount"; Decimal) { }
        Field(51710; "G/L Comm. Payable Amount"; Decimal) { }
        Field(60000; "945 Processed"; Boolean) { }
        Field(65000; "Master Order No."; Code[20]) { }
        Field(70553; "IspickupOrder"; Boolean) { }

    }
}
