tableextension 50111 SalesShipmentHeader extends "Sales Shipment Header"
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
        Field(50097; "Customer Comments"; Text[80]) { }
        Field(50098; "Finance Comments"; Text[80]) { }
        Field(50099; "Shipping Comments"; Text[80]) { }
        Field(50100; "Mfr. Rep. Code"; Code[20]) { }
        Field(50101; "ISR Code"; Code[10]) { }
        Field(50102; "CSR Code"; Code[10]) { }
        Field(50108; "SignatureImage"; blob) { }
        Field(50109; "No. Of Cartons"; Integer) { }
        Field(50110; "Full Name"; Text[50]) { }
        Field(50111; "Check No."; Integer) { }
        Field(50112; "Check Amount"; Decimal) { }
        Field(50113; "Signature Date"; Date) { }
        Field(50200; "Shortcut Dimension 5 Code"; Code[20]) { }
        Field(50300; "No. of Posted Packages"; Integer) { }
        Field(51029; "Warehouse Release No."; Code[20]) { }
        Field(51409; "Free Freight Reason Code"; Code[10]) { }
        Field(51480; "Ship-to Phone No."; Text[30]) { }
        Field(60000; "945 Processed"; Boolean) { }
        Field(65000; "Master Order No."; Code[20]) { }

    }
}
