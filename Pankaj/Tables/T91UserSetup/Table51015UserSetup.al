tableextension 50105 UserSetupExt extends "User Setup"
{
    fields
    {
        Field(50000; "Default Location"; Code[10]) { }
        Field(50001; "Default Division"; Code[10]) { }
        Field(50015; "Sales Margin % Approver"; Boolean) { }
        Field(50016; "Credit Limit Approver"; Boolean) { }
        Field(50017; "Line Pricing Approver"; Boolean) { }
        Field(50018; "Overdue Bal. Approver"; Boolean) { }
        Field(50019; "Shortcut Dimension 5 Filter"; Text[250]) { }
        Field(50030; "Price Book Filter"; Code[50]) { }
        Field(50100; "Mfr. Rep. Filter"; Code[20]) { }
        Field(50101; "Mfr. Rep. Filter (L)"; Code[20]) { }
        Field(50102; "Mfr. Rep. Filter (P)"; Code[20]) { }
        Field(50105; "Location Filter"; Code[20]) { }
        Field(50200; "Shortcut Dimension 5 Code"; Code[20]) { }
        Field(50300; "Allow Sales CM Posting"; Boolean) { }
        Field(51005; "OSR/CSR/ISR/Mfr. Rep. Admin."; Boolean) { }
        Field(51074; "Manual Margin Approval"; Boolean) { }
        Field(51406; "Min. Order Amount Approval"; Boolean) { }
        Field(51407; "Free Freight Approval"; Boolean) { }
        Field(51700; "Comm. / Hdlg Admin."; Boolean) { }
        Field(51701; "User signature"; Text[250]) { }
        Field(51702; "User SMTP Override"; Boolean) { }
        Field(51704; "Warehouse Employee"; Boolean) { }
        Field(51705; "DSHIP API Integration"; Boolean) { }

    }
}