table 50250 "Contact Feeder Entry"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            AutoIncrement = true;

        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            trigger OnValidate()
            begin
                GetCust;
                //GetCustDivision;
            end;

        }
        FIeld(3; "Customer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIeld(4; "Customer Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIeld(5; "Customer Address"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIeld(6; "Customer Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIeld(7; "Customer City"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF ("Sell-to Country/Region Code" = CONST()) "Post Code".City ELSE
            IF ("Sell-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Sell-to Country/Region Code"));
            ValidateTableRelation = false;
            //TestTableRelation = false;
        }
        FIeld(8; "Customer Contact"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            //ValidateTableRelation = false;
            //TestTableRelation = false;
        }
        FIeld(10; "Customer Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = IF ("Sell-to Country/Region Code" = CONST()) "Post Code" ELSE
            IF ("Sell-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Sell-to Country/Region Code"));
            ValidateTableRelation = false;
            //TestTableRelation = false;
        }
        FIeld(11; "Customer County"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            //TableRelation = "County".Code WHERE ("Country/Region Code"=FIELD("Sell-to Country/Region Code"));
        }
        FIeld(12; "Sell-to Country/Region Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Country/Region";
        }
        FIeld(13; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = IF (Type=CONST(Customer)) "Customer Division"."Shortcut Dimension 5 Code" WHERE ("Customer No.""=FIELD("Customer No.")) ELSE IF (Type=CONST(Prospect)) "Dimension Value".Code WHERE (Dimension Code=CONST(DIVISION));
        }
        FIeld(14; "RSM Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Salesperson/Purchaser";
        }
        FIeld(15; "ISR Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Salesperson/Purchaser";
        }
        FIeld(16; "OSR Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Salesperson/Purchaser";
        }
        FIeld(17; "CSR Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Salesperson/Purchaser";
        }
        FIeld(18; "Job Responsibility"; Text[50])
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            TableRelation = "Job Responsibility".Description;
            ValidateTableRelation = false;
            // TestTableRelation = false;
        }
        FIeld(19; "Job Title"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        FIeld(20; "First Name"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        FIeld(21; "Last Name"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        FIeld(22; "E-Mail Address"; Text[80])
        {
            DataClassification = ToBeClassified;

        }
        FIeld(23; "Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        FIeld(24; "Mobie Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;

        }
        FIeld(25; "Address"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        FIeld(26; "Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;

        }
        FIeld(27; "City"; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;
            //TestTableRelation = false;
        }
        FIeld(28; "County"; Text[30])
        {
            DataClassification = ToBeClassified;
            // TableRelation = County.Code WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        FIeld(29; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code" ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;
            //TestTableRelation = false;
            Trigger Onvalidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            END;
        }
        FIeld(30; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            // TestTableRelation = false;
        }
        FIeld(31; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIeld(32; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIeld(33; "Country/Region Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";

        }
        FIeld(34; "Ship-to Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
            trigger OnValidate()
            VAR
                ShipToAddr: Record "Ship-to Address";
                SellToCustTemplate: Record "Customer Templ.";
            begin
                IF "Ship-to Code" <> '' THEN BEGIN
                    ShipToAddr.GET("Customer No.", "Ship-to Code");
                    //ShipToAddr.TESTFIELD(Blocked,FALSE);
                    Address := ShipToAddr.Address;
                    "Address 2" := ShipToAddr."Address 2";
                    City := ShipToAddr.City;
                    "Post Code" := ShipToAddr."Post Code";
                    County := ShipToAddr.County;
                    "E-Mail Address" := ShipToAddr."E-Mail";
                    VALIDATE("Country/Region Code", ShipToAddr."Country/Region Code");
                    "Phone Number" := ShipToAddr."Phone No.";
                END ELSE BEGIN
                    Address := '';
                    "Address 2" := '';
                    City := '';
                    "Post Code" := '';
                    County := '';
                    "E-Mail Address" := '';
                    VALIDATE("Country/Region Code", '');
                    "Phone Number" := '';
                END;
            end;
        }
        FIeld(35; "Synched"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        FIeld(36; "Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Customer,Prospect;
        }
        FIeld(37; "Contact No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Contact;
        }
        FIeld(38; "Email Exist as Customer"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIeld(39; "Email Exist as Prospect"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIeld(40; "Ship-to Name"; text[100])
        {

            FieldClass = FlowField;
            CalcFormula = Lookup("Ship-to Address".Name WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;
        }
        FIeld(41; "Prospect Company Name"; text[100])
        {

            FieldClass = FlowField;
            CalcFormula = Lookup("Ship-to Address".Name WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;
        }
        FIeld(42; Pricing; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        FIeld(43; Marketing; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        ContFeederEntry: Record "Contact Feeder Entry";
        PostCode: Record "Post Code";
        Text50000: TextConst ENU = 'Customer Type contact must not have Prospect job responsibility, Please select type Prospect for prospect Job Responsibilty.';
        Text50001: TextConst ENU = 'Prospect Type contact must have Prospect job responsibility, Please select type contact for other Job Responsibilties.';
        Pos: Integer;

    trigger OnInsert()
    begin
        IF "Line No." <> 0 THEN BEGIN
            ContFeederEntry.RESET;
            IF ContFeederEntry.GET("Entry No.", 0) THEN BEGIN

                Type := ContFeederEntry.Type;
                IF Type = Type::Prospect THEN
                    IF "Line No." > 0 THEN
                        ERROR('Only one Line is allowed in Prospect Contact');

                "Customer No." := ContFeederEntry."Customer No.";
                "Customer Name" := ContFeederEntry."Customer Name";
                "Customer Name 2" := ContFeederEntry."Customer Name 2";
                "Customer Address" := ContFeederEntry."Customer Address";
                "Customer Address 2" := ContFeederEntry."Customer Address 2";
                "Customer City" := ContFeederEntry."Customer City";
                "Customer Contact" := ContFeederEntry."Customer Contact";
                "Customer Post Code" := ContFeederEntry."Customer Post Code";
                "Customer County" := ContFeederEntry."Customer County";
                "Sell-to Country/Region Code" := ContFeederEntry."Sell-to Country/Region Code";
                "RSM Code" := ContFeederEntry."RSM Code";
                "Shortcut Dimension 5 Code" := ContFeederEntry."Shortcut Dimension 5 Code";
                "ISR Code" := ContFeederEntry."ISR Code";
                "OSR Code" := ContFeederEntry."OSR Code";
                "CSR Code" := ContFeederEntry."CSR Code";
            END;
        END;

        "User ID" := USERID;
        "Date Created" := TODAY;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    LOCAL PROCEDURE GetCust();
    VAR
        Customer: Record customer;
    BEGIN

        IF Customer.GET("Customer No.") THEN BEGIN
            "Customer Name" := Customer.Name;
            "Customer Name 2" := Customer."Name 2";
            "Customer Address" := Customer.Address;
            "Customer Address 2" := Customer."Address 2";
            "Customer City" := Customer.City;
            "Customer Contact" := Customer.Contact;
            "Customer Post Code" := Customer."Post Code";
            "Customer County" := Customer.County;
            "Sell-to Country/Region Code" := Customer."Country/Region Code";
            // "RSM Code"          := Customer."RSM Code" ;
        END;
    END;

    /*
    LOCAL PROCEDURE GetCustDivision();
    VAR
      CustDivision : Record 50007;
    BEGIN
      IF ("Customer No." <> '') AND ("Shortcut Dimension 5 Code" <> '') THEN BEGIN
          IF CustDivision.GET("Customer No.","Shortcut Dimension 5 Code")THEN BEGIN
           "ISR Code" := CustDivision."ISR Code";
           "OSR Code" := CustDivision."Salesperson Code";
           "CSR Code" := CustDivision."CSR Code";
          END;
      END;
    END;
    */
}