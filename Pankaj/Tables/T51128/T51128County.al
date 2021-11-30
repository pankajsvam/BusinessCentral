table 51128 County
{
    // version TPZ000.00.00

    // 2015-04-08 TPZ416 VCHERNYA
    //   Table has been created

    Caption = 'State';
    DataCaptionFields = "Country/Region Code", "Code", Name;
    //DrillDownPageID = Counties;
    //LookupPageID = Counties;

    fields
    {
        field(1; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            NotBlank = true;
            TableRelation = "Country/Region";
        }
        field(2; "Code"; Code[30])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(4; "Region Code"; Code[10])
        {
            Caption = 'Region Code';
            //TableRelation = Region;
        }
        field(5; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
    }

    keys
    {
        key(Key1; "Country/Region Code", "Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Name)
        {
        }
    }
}

