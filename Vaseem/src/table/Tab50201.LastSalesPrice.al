table 50201 "Last Sales Price"
{
    // version TOP010,180,230,SQLPerform,TPZ2651,TPZ2970,001

    // TOP010 KT ABCSI Stock Status Quick Quote Screen 12182014
    //   -  Created table for Last Sales Price
    // 
    // TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015
    //   - Added new key
    // 
    // TOP230 KT ABCSI CRP 2 Fixes 06162015
    //   - Modified the DecimalPlaces property and AutoFormatType property for all the custom fields with Quantity, Price and Amounts
    // 
    // 2015-06-30 TPZ449 VCHERNYA
    //   Division Code (Shortcut Dimension 5 Code) and Country/Region Code fields have been created
    // 2016-04-11 TPZ1482 TAKHMETO
    //   Customer Name and Item Description have been added
    // 2016-04-11 TPZ1482 TAKHMETO
    //   Customer Name and Item Description have been added
    // 2016-06-17 TPZ1601 EBAGIM
    //   Loaction Code have been added
    // 2017-09-29 TPZ2000 EBAGIM
    //   Item Multiplier Group have been added
    // 2018-12-27 SQLPerform AKB
    //   Added key “Sell-to Customer No.”,"Item No.”,”Unit of Measure Code”,”Document Type”
    // 2019-10-23 TPZ2651 VAHAMAD
    //   Added Field Scaled
    // TPZ2970 VAH 112520202 Added new field :Special Price
    // 001 TPZ3163 UTK 06162021 Added new Field 'Lighting Price Update date'.


    fields
    {
        field(10; "Document Type"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Posted Sales Invoice,Stock Status';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Posted Sales Invoice","Stock Status";
        }
        field(20; "Document No."; Code[20])
        {
        }
        field(30; "Sell-to Customer No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate();
            begin
                // <TPZ1014>
                if Customer.GET("Sell-to Customer No.") then
                    "Customer Group Code" := Customer."Customer Group Code"
                else
                    "Customer Group Code" := '';
                // <TPZ1014>
            end;
        }
        field(31; "Sell-to Customer Name"; Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Sell-to Customer No.")));
            CaptionML = ENU = 'Sell-to Customer Name',
                        ESM = 'Venta a-Nombre',
                        FRC = 'Nom du client (débiteur)',
                        ENC = 'Sell-to Customer Name';
            FieldClass = FlowField;
        }
        field(40; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(41; "Item Description"; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Description';
            FieldClass = FlowField;
        }
        field(45; "Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Unit of Measure Code',
                        ESM = 'Cód. unidad medida',
                        FRC = 'Code unité de mesure',
                        ENC = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(50; "Document Date"; Date)
        {
        }
        field(60; "Line No."; Integer)
        {
        }
        field(70; "Last Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            DecimalPlaces = 4 : 4;
        }
        field(80; "Last Price UOM"; Code[10])
        {
        }
        field(90; "Last Price Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(100; "Last Price Date"; Date)
        {
        }
        field(110; "Last Price User ID"; Code[50])
        {
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup();
            begin
                //UserMgt.LookupUserID("Last Price User ID");//TODO:
            end;

            trigger OnValidate();
            begin
                //UserMgt.ValidateUserID("Last Price User ID");//TODO:
            end;
        }
        field(120; "Product Group Code"; Code[20])
        {
            //CalcFormula = Lookup(Item."Product Group Code" WHERE("No." = FIELD("Item No.")));//TODO:
            //FieldClass = FlowField;
        }
        field(130; "Item Category Group"; Code[30])
        {
            CalcFormula = Lookup(Item."Item Category Code" WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(51000; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';

            trigger OnLookup();
            begin
                // <TPZ449>
                DimMgt.LookupDimValueCode(5, "Shortcut Dimension 5 Code");
                // </TPZ449>
            end;

            trigger OnValidate();
            begin
                // <TPZ449>
                DimMgt.ValidateDimValueCode(5, "Shortcut Dimension 5 Code");
                // </TPZ449>
            end;
        }
        field(51002; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(51051; "Customer Group Code"; Code[10])
        {
            Caption = 'Customer Group Code';
            Editable = false;
            //TableRelation = "Customer Group";//TODO:
        }
        field(51052; "Location Code"; Code[10])
        {
            CalcFormula = Lookup("Sales Invoice Header"."Location Code" WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(51053; "Old Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(51054; "Item Multiplier Group"; Code[10])
        {
            CalcFormula = Lookup(Item."Item Disc. Group" WHERE("No." = FIELD("Item No.")));
            Description = 'TPZ2000';
            FieldClass = FlowField;
        }
        field(51055; "Price Increase"; Boolean)
        {
            Description = 'TPZ2447';
        }
        field(51056; "Pre Increase Unit Price"; Decimal)
        {
            Description = 'TPZ2447';
        }
        field(51057; Scaled; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ2651';
        }
        field(51058; "Special Price"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ2970';
        }
        field(51059; "Lighting Price Update date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ3163';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Sell-to Customer No.", "Item No.", "Unit of Measure Code")
        {
        }
        key(Key2; "Sell-to Customer No.", "Item No.", "Document Date")
        {
        }
        key(Key3; "Sell-to Customer No.", "Item No.", "Unit of Measure Code", "Document Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Customer: Record Customer;
        UserMgt: Codeunit "User Management";
        DimMgt: Codeunit DimensionManagement;
}

