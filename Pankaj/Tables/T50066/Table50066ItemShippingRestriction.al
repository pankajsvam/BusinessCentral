table 50066 "Item Shipping Restriction"
{
    // version 3151,002

    // 001 TPZ3151 UTK 06302021 Created new table for Shipping Mode restriction Setup.
    // 002 TPZ3305 UTK 08252021 Added Stock Rep option in Restriction Type.


    fields
    {
        field(1; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        field(2; "Restriction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Country,State,"Shipping Mode",Customer,"Stock Rep";
        }
        field(3; "Restriction Code 1"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Restriction Type" = CONST(Country)) "Country/Region".Code
            ELSE
            IF ("Restriction Type" = CONST(State)) County.Code
            ELSE
            IF ("Restriction Type" = CONST("Shipping Mode")) "Shipping Agent".Code
            ELSE
            IF ("Restriction Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Restriction Type" = CONST("Stock Rep")) Location.Code;

            trigger OnValidate();
            var
                County: Record County;
                CountryRegion: Record "Country/Region";
                ShippingAgent: Record "Shipping Agent";
                Customer: Record Customer;
                Location: Record Location;
            begin
                case "Restriction Type" of
                    "Restriction Type"::" ":
                        "Restriction Code Description" := '';
                    "Restriction Type"::Country:
                        begin
                            if CountryRegion.GET("Restriction Code 1") then
                                "Restriction Code Description" := CountryRegion.Name
                            else
                                "Restriction Code Description" := '';
                        end;
                    "Restriction Type"::State:
                        begin
                            County.RESET;
                            County.SETRANGE(Code, "Restriction Code 1");
                            if County.FINDFIRST then
                                "Restriction Code Description" := County.Name
                            else
                                "Restriction Code Description" := '';
                        end;
                    "Restriction Type"::"Shipping Mode":
                        begin
                            ShippingAgent.RESET;
                            ShippingAgent.SETRANGE(Code, "Restriction Code 1");
                            if ShippingAgent.FINDFIRST then
                                "Restriction Code Description" := ShippingAgent.Name
                            else
                                "Restriction Code Description" := '';
                        end;
                    "Restriction Type"::Customer:
                        begin
                            Customer.RESET;
                            Customer.SETRANGE("No.", "Restriction Code 1");
                            if Customer.FINDFIRST then
                                "Restriction Code Description" := Customer.Name
                            else
                                "Restriction Code Description" := '';
                        end;
                    //<TPZ3305>
                    "Restriction Type"::"Stock Rep":
                        begin
                            Location.RESET;
                            Location.SETRANGE(Code, "Restriction Code 1");
                            if Location.FINDFIRST then
                                "Restriction Code Description" := Location.Name
                            else
                                "Restriction Code Description" := '';
                        end;
                //<TPZ3305>
                end;
            end;
        }
        field(4; "Restriction Code 2"; Code[30])
        {
            DataClassification = ToBeClassified;
            //TableRelation = IF ("Restriction Type"=CONST("Shipping Mode")) "E-Ship Agent Service".Code WHERE ("Shipping Agent Code"=FIELD("Restriction Code 1"));
        }
        field(5; "Restriction Code Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Restriction Type", "Restriction Code 1", "Restriction Code 2")
        {
        }
    }

    fieldgroups
    {
    }
}

