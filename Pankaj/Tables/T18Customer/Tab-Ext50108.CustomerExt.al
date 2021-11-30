tableextension 50108 CustomerExt extends Customer
{
    fields
    {
        Field(50000; "Payment Terms Code to Print"; Code[10]) { }
        Field(50010; "Division Code Filter"; Code[20]) { }
        Field(50020; "Show Customer Item No on Docs"; boolean) { }
        Field(50030; "Non Divisional"; boolean) { }
        Field(50035; "RSM Code"; Code[10]) { }
        Field(50097; "Customer Comments"; Text[80]) { }
        Field(50098; "Finance Comments"; Text[80]) { }
        Field(50099; "Shipping Comments"; Text[80]) { }
        Field(50100; "No. of Quote Lines"; Integer) { }
        Field(50101; "No. of Order Lines"; Integer) { }
        Field(50102; "No. of Pstd. Shipment Lines"; Integer) { }
        Field(50103; "No. of Pstd. Invoice Lines"; Integer) { }
        Field(50104; "No. of Archive Quote Lines"; Integer) { }
        Field(50105; "No. of Archive Order Lines"; Integer) { }
        Field(51002; "Last Modified by User ID"; Code[50]) { }
        Field(51003; "Date Created"; date) { }
        Field(51004; "Credit Hold Override"; boolean) { }
        Field(51005; "Created by User ID"; Code[50]) { }
        Field(51006; "Mail"; boolean) { }
        Field(51007; "Fax"; boolean) { }
        Field(51008; "E-Mail List"; boolean) { }
        Field(51009; "EDI"; boolean) { }
        Field(51015; "Send Statement As Excel"; boolean) { }
        Field(51026; "Last Invoice Date"; date) { }
        Field(51041; "DUNS No."; Code[9]) { }
        Field(51051; "Customer Group Code"; Code[10]) { }
        Field(51059; "CMG"; boolean) { }
        Field(51096; "External Document No. Mask"; Code[35]) { }
        Field(51097; "Ship-to Code Mandatory"; boolean) { }
        Field(51099; "Mailing Label"; boolean) { }
        Field(51100; "Primary Sales Contact No."; Code[20]) { }
        Field(51101; "Primary Sales Contact"; Text[50]) { }
        Field(51102; "Sales Phone No."; Text[30]) { }
        Field(51103; "Sales Phone No. 2"; Text[30]) { }
        Field(51104; "Sales Fax No."; Text[30]) { }
        Field(51105; "Sales Fax No. 2"; Text[30]) { }
        Field(51106; "Sales E-Mail"; Text[80]) { }
        Field(51107; "Sales E-Mail 2"; Text[80]) { }
        Field(51110; "Phone No. 2"; Text[30]) { }
        Field(51111; "Invoice Fax No."; Text[30]) { }
        Field(51112; "Statement Fax No."; Text[30]) { }
        Field(51113; "Fax No. 2"; Text[30]) { }
        Field(51124; "BG Affiliation Code"; Code[10]) { }
        Field(51125; "Buying Group Code"; Code[10]) { }
        Field(51126; "Buying Group Cust. No."; Code[20]) { }
        Field(51127; "Region Code"; Code[10]) { }
        Field(51129; "District"; Text[30]) { }
        Field(51150; "GainShare Program"; boolean) { }
        Field(51151; "Gateway to Growth Program"; boolean) { }
        Field(51900; "Electric Mfr. Rep. Code"; Code[10]) { }
        Field(51901; "Electric Salesperson Code"; Code[10]) { }
        Field(51902; "Electric ISR Code"; Code[10]) { }
        Field(51903; "Electric CSR Code"; Code[10]) { }
        Field(51904; "Electric Location Code"; Code[10]) { }
        Field(51908; "Electric Division"; boolean) { }
        Field(51910; "Lighting Mfr. Rep. Code"; Code[10]) { }
        Field(51911; "Lighting Salesperson Code"; Code[10]) { }
        Field(51912; "Lighting ISR Code"; Code[10]) { }
        Field(51913; "Lighting CSR Code"; Code[10]) { }
        Field(51914; "Lighting Location Code"; Code[10]) { }
        Field(51918; "Lighting Division"; boolean) { }
        Field(51919; "Conduit Mfr. Rep. Code"; Code[10]) { }
        Field(51920; "Conduit Division"; boolean) { }
        Field(51921; "Conduit ISR Code"; Code[10]) { }
        Field(51922; "Conduit CSR Code"; Code[10]) { }
        Field(51923; "Conduit Salesperson Code"; Code[10]) { }
        Field(51924; "International Location Code"; Code[10]) { }
        Field(51928; "International Division"; boolean) { }
        Field(51929; "Enable Blank Packing Slip"; boolean) { }
        Field(51930; "Gain Share"; Decimal) { }
        Field(70551; "Redirect Usage"; Enum Customer_RedirectUsage) { }
        Field(70552; "Customer Redirect Exists"; boolean) { }
        Field(70553; "Ship-to Redirect Exists"; boolean) { }
        Field(70554; "Exclude From Usage"; boolean) { }
        Field(70556; "Lighting Price File"; date) { }
        Field(70557; "Print UPC Code On Packing Slip"; boolean) { }

    }
}
