table 50101 Division
{
    Caption = 'Division';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        Field(2; "Name"; Text[50]) { }
        Field(51004; "Use Last Price as Recomm Price"; Boolean) { }
        Field(51005; "OSR Code Mandatory"; Boolean) { }
        Field(51006; "Mfr. Rep. Code Mandatory"; Boolean) { }
        Field(51160; "Enable Post with Job Queue"; Boolean)
        {
            trigger OnValidate()
            begin
                // <TPZ1201>
                IF "Enable Post with Job Queue" THEN
                    TESTFIELD("Posting Date Check on Posting", FALSE);
                // </TPZ1201>
            end;
        }
        Field(51470; "Min. Order Amount"; Decimal) { }
        Field(51480; "Posting Date Check on Posting"; Boolean)
        {
            trigger OnValidate()
            begin
                // <TPZ1201>
                IF "Posting Date Check on Posting" THEN
                    TESTFIELD("Enable Post with Job Queue", FALSE);
                // </TPZ1201>
            end;
        }
        Field(51700; "Line Item Ref. on Documents"; enum Division_LineItemRefonDoc) { }

    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

}
