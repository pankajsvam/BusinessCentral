tableextension 50251 CntactTableextend extends Contact
{
    fields
    {
        /* field(50100; "Blocked Customer"; Option)
         {
             Caption = 'Blocked Customer';
             OptionMembers = ,Ship,Invoice,All;
             FieldClass = FlowField;
             // CalcFormula = Lookup(Customer.Blocked WHERE("No." = FIELD("Customer No.")));
         }
         /* field(50101; "Date Created"; Date)
        {
            Caption = 'Date Created';
            DataClassification = ToBeClassified;
        }
        field(50102; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }*/
        field(50103; "Prospect to Customer"; Date)
        {
            Caption = 'Prospect to Customer';
            DataClassification = ToBeClassified;
        }
        field(50104; "Prospect Converted By"; Code[50])
        {
            Caption = 'Prospect Converted By';
            DataClassification = ToBeClassified;
        }
        field(50105; "Shortcut Dimension 5 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
        }
        field(50106; "ISR Code"; Code[20])
        {
            Caption = 'ISR Code';
            FieldClass = FlowField;
            //CalcFormula = Lookup(Customer."No." WHERE("No." = FIELD("Customer No.")));
        }
        field(50107; "CSR Code"; Code[10])
        {
            Caption = 'CSR Code';
            DataClassification = ToBeClassified;
        }
        field(50108; "OSR Code"; Code[10])
        {
            Caption = 'OSR Code';
            DataClassification = ToBeClassified;
        }
        field(50109; "RSM Code"; Code[10])
        {
            Caption = 'RSM Code';
            DataClassification = ToBeClassified;
        }
        field(50110; "Job Responsibility"; Code[10])
        {
            Caption = 'Job Responsibility';
            FieldClass = FlowField;
            CalcFormula = Lookup("Contact Job Responsibility"."Job Responsibility Code" WHERE("Contact No." = FIELD("No.")));
            TableRelation = "Job Responsibility";
        }
        /*field(50111; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Contact Business Relation"."No." WHERE("Link to Table" = CONST(Customer), "Contact No." = FIELD("Company No.")));
        }*/
        field(50112; "Job Responsibility Description"; Text[100])
        {
            Caption = 'Job Responsibility Description';
            FieldClass = FlowField;
            CalcFormula = Lookup("Job Responsibility".Description WHERE(Code = FIELD("Job Responsibility")));
            Editable = false;
            TableRelation = "Job Responsibility";
        }
        field(50113; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            DataClassification = ToBeClassified;
            // TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
            trigger OnValidate()
            var
                ShipToAddr: Record 222;
            Begin
                IF "Ship-to Code" <> '' then begin
                    //ShipToAddr.GET("Customer No.", "Ship-to Code");
                    //ShipToAddr.TESTFIELD(Blocked,FALSE);
                    Address := ShipToAddr.Address;
                    "Address 2" := ShipToAddr."Address 2";
                    City := ShipToAddr.City;
                    "Post Code" := ShipToAddr."Post Code";
                    County := ShipToAddr.County;
                    "E-Mail" := ShipToAddr."E-Mail";
                    VALIDATE("Country/Region Code", ShipToAddr."Country/Region Code");
                    "Phone No." := ShipToAddr."Phone No.";
                END ELSE BEGIN
                    Address := '';
                    "Address 2" := '';
                    City := '';
                    "Post Code" := '';
                    County := '';
                    "E-Mail" := '';
                    VALIDATE("Country/Region Code", '');
                    "Phone No." := '';
                END;
            End;

        }
        field(50114; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            FieldClass = FlowField;
            //CalcFormula = Lookup("Ship-to Address".Name WHERE("Customer No." = FIELD("Customer No."), Code = FIELD("Ship-to Code")));
            Editable = false;

        }
        field(50115; "Mfr. Rep. Code"; Code[20])
        {
            Caption = 'Mfr. Rep. Code';
            DataClassification = ToBeClassified;
        }
        field(50116; Pricing; Boolean)
        {
            Caption = 'Pricing';
            DataClassification = ToBeClassified;
        }
        field(50117; Marketing; Boolean)
        {
            Caption = 'Marketing';
            DataClassification = ToBeClassified;
        }
        field(50118; "Prospect Company Name"; Text[50])
        {
            Caption = 'Prospect Company Name';
            DataClassification = ToBeClassified;
        }
        field(50050; "Date Created"; date)
        {

        }
        Field(50051; "Created By"; code[50])
        {

        }
        field(60007; "Customer No."; Code[20])
        {

        }
        field(50000; "Blocked Customer"; Enum "Customer Blocked")
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Blocked
            WHERE("No." = Field("Customer No.")));

        }
    }
}
