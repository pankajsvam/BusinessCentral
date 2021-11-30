table 50149 "Contact Buffer"
{
    Caption = 'Contact Buffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Option"; Text[50])
        {
            Caption = 'Option';
            DataClassification = ToBeClassified;
        }
        field(2; "Option Choice"; Text[50])
        {
            Caption = 'Option Choice';
            DataClassification = ToBeClassified;
        }

        field(3; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
        }

        Field(43; "DefaultCode 20"; Code[20])
        {

        }
        Field(44; "DefaultCode 20_1"; Code[20])
        {

        }
        Field(5; "DefaultCode 20_2"; Code[20])
        {

        }
        Field(6; "DefaultCode 20_3"; Code[20])
        {

        }
        Field(7; "DefaultText 30"; Text[30])
        {

        }
        Field(8; "DefaultText 30_1"; Text[30])
        {

        }
        Field(9; "DefaultText 30_2"; Text[30])
        {

        }
        Field(10; "DefaultText 30_3"; Text[30])
        {

        }
        Field(11; DefaultText250; Text[250])
        {

        }
        Field(12; DefaultText250_1; Text[250])
        {

        }
        Field(13; "User ID"; Text[50])
        {

        }
        Field(14; "Default Boolean"; Boolean)
        {

        }
        Field(15; "Default Boolean_1"; Boolean)
        {

        }
        Field(16; "To Email"; Text[250])
        {

        }
        Field(17; "CC Email"; Text[250])
        {

        }
        Field(18; DefaultDate; Date)
        {

        }
        Field(19; "Bcc Email"; Text[80])
        {

        }
        Field(20; DefaultDecimal; Decimal)
        {

        }
        Field(21; DefaultDecimal_1; Decimal)
        {

        }
        Field(22; DefaultInteger; Integer)
        {

        }
        Field(23; DefaultInteger_1; Integer)
        {

        }
        Field(24; DefaultDate1; Date)
        {

        }
        Field(25; DefaultInteger_2; Integer)
        {

        }
        Field(26; DefaultInteger_3; Integer)
        {

        }
        Field(27; DefaultInteger_4; Integer) { }
        Field(28; DefaultInteger_5; Integer) { }
        Field(29; DefaultInteger_6; Integer) { }
        Field(30; DefaultInteger_7; Integer) { }
        Field(31; DefaultInteger_8; Integer) { }
        Field(32; DefaultInteger_9; Integer) { }
        Field(33; DefaultInteger_10; Integer) { }
        Field(34; DefaultInteger_11; Integer) { }
        Field(35; DefaultInteger_12; Integer) { }
        Field(36; "Default DateTime"; DateTime) { }
        Field(37; "Default DateTime_1"; DateTime) { }
        Field(38; DefaultTime; Time) { }
        Field(39; DefaultTime_1; Time) { }
        Field(40; DefaultDate2; Date) { }
        Field(41; "Division Code"; Code[20]) { }
        Field(42; Integer_1; Integer) { }

    }
    keys
    {
        key(PK; "Option", "Option Choice")
        {
            Clustered = true;
        }
        key(Secondry; DefaultInteger)
        {

        }
    }

}
