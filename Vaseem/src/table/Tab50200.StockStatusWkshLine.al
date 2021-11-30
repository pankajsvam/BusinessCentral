table 50200 "Stock Status Wksh. Line"
{
    Caption = 'Stock Status Wksh. Line';
    // version TOP010,130,230,010E,RS1.04,TPZ2531,TPZ2839,TPZ2785,001,002,TPZ2970,TPZ3090

    // TOP010 KT ABCSI Stock Status Quick Quote Screen 12082014
    //   - Main table for Stock Status Quick Quote
    // TOP130 KT ABCSI Item List Sort and Filter by Status 04082015
    //   - Added a new field "Blocked Sequence"
    // TOP230 KT ABCSI CRP 2 Fixes 05202015
    //   - Set the AutoFormatType property to 2 for pricing/cost fields
    //   - Added new fields "Recomm. Unit Price", "Recomm. Multiplier"
    //   - code to populate Reason Code Comment on OnValidate trigger of Reason Code field
    //   - Added a new field Lost Opportunity Description
    // TOP010E KT ABCSI Additional Stock Status 07282015
    //   - Added a new field 'Last Price User ID'
    // 2015-06-19 TPZ591 VCHERNYA
    //   Sorting Order field has been created
    // 2016-03-09 TPZ1470 TAKHMETO
    //   Temp Order No. field added
    // 2016-07-08 TPZ1545 EBAGIM
    //   Add NPI Blocking option to Blocked field
    // 2018.11.09 BUG2386 RIS  - revamp code to eliminate error failures
    // 2018-11-20 TPZ2447 AKUMAR
    //   Added "Pre Increase Unit Price" and "Post Increase Unit Price"
    // 2019-05-03 TPZ2531 UCHOUHAN
    //   Removed NPI Blocked option
    // 2020-05-13 TPZ2839 UCHOUHAN
    //   Added new field 'ABC Code'.
    // TPZ2785 05112020 GGUPTA Remove Item blocking Topaz Customization
    // TPZ2859 05192020 RSAH
    //   - Filter Item by attribute on the stock status screen
    // 001 TPZ2881 PKS 07232020  Added new fields Average Unit Cost and Gross Margin % Avg Cost
    // 001 TPZ2970 VAH 11252020 Added new field : Special Price


    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
        }
        field(6; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(7; "Location Code"; Code[10])
        {
            TableRelation = Location.Code WHERE("Use As In-Transit" = CONST(false));
        }
        field(8; "Base Unit of Measure"; Code[10])
        {
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(11; Description; Text[50])
        {
        }
        field(12; "Description 2"; Text[70])
        {
        }
        field(19; "Order Date"; Date)
        {
        }
        field(22; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(23; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(32; "Vendor Item No."; Text[30])
        {
        }
        field(54; Blocked; Boolean)
        {
        }
        field(84; "Qty. on Purch. Order"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(85; "Qty. on Sales Order"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Order),
                                                                            Type = CONST(Item),
                                                                            "No." = FIELD("Item No."),
                                                                            "Location Code" = FIELD("Location Code"),
                                                                            "Drop Shipment" = CONST(false)));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(95; "Country/Region of Origin Code"; Code[10])
        {
            CaptionML = ENU = 'Country/Region of Origin Code',
                        ESM = 'Cód. país/región de origen',
                        FRC = 'Code pays/région origine',
                        ENC = 'Country/Region of Origin Code';
            TableRelation = "Country/Region";
        }
        field(800; "Location Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5701; "Manufacturer Code"; Code[10])
        {
            CaptionML = ENU = 'Manufacturer Code',
                        ESM = 'Cód. fabricante',
                        FRC = 'Code fabricant',
                        ENC = 'Manufacturer Code';
            TableRelation = Manufacturer;
        }
        field(5709; "Item Category Code"; Code[10])
        {
            CaptionML = ENU = 'Item Category Code',
                        ESM = 'Cód. categoría producto',
                        FRC = 'Code catégorie',
                        ENC = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(5712; "Product Group Code"; Code[10])
        {
            CaptionML = ENU = 'Product Group Code',
                        ESM = 'Cód. grupo producto',
                        FRC = 'Code groupe produits',
                        ENC = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(5777; "Qty. on Pick Loc."; Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding (Base)" WHERE("Activity Type" = CONST(Pick),
                                                                                         "Item No." = FIELD("Item No."),
                                                                                         "Location Code" = FIELD("Location Code"),
                                                                                         "Action Type" = FILTER(" " | Take),
                                                                                         "Breakbulk No." = CONST(0)));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000; "Quantity Available on Location"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50001; "Main Loc. Qty. Avail"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50002; "Last Quoted Unit Price"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(50003; "Last Quoted UOM"; Code[10])
        {
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(50004; "Last Quoted Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50005; "Current Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50006; "Current UOM"; Code[10])
        {
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(50007; "Last Unit Price"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(50008; "Last Price UOM"; Code[10])
        {
            Editable = false;
        }
        field(50009; "Last Price Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50010; "Last Reason Code"; Code[10])
        {
            TableRelation = "Reason Code";
        }
        field(50011; "Last Reason Code Comment"; Text[60])
        {
        }
        field(50012; "Last Lost Opportunity"; Boolean)
        {
        }
        field(50013; "Last Price Date"; Date)
        {
            Editable = false;
        }
        field(50014; "Last Invoice Price"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(50015; "Last Invoiced Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50016; "Cust. Qty. on SO"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Order),
                                                                            Type = CONST(Item),
                                                                            "Sell-to Customer No." = FIELD("Sell-to Customer No."),
                                                                            "No." = FIELD("Item No."),
                                                                            "Location Code" = FIELD("Location Code"),
                                                                            "Drop Shipment" = CONST(false)));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50017; "Qty. on Hand"; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0 : 5;
        }
        field(50018; "Total Qty. on Hand"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50019; "Qty. Avail. to Pick"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            FieldClass = Normal;
        }
        field(50020; "Promotion Code"; Code[10])
        {
        }
        field(50021; "Curr. Unit Price Starting Date"; Date)
        {
        }
        field(50022; "Curr. Unit Price Ending Date"; Date)
        {
        }
        field(50023; "Low Unit Price"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(50024; "High Unit Price"; Decimal)
        {
            AutoFormatType = 2;

            trigger OnValidate();
            begin
                "MSRP Price" := "High Unit Price" * 1.6;//TPZ3090
            end;
        }
        field(50025; "Last Price Change Date"; Date)
        {
        }
        field(50026; "Lost Opportunity"; Boolean)
        {
        }
        field(50027; "Reason Code"; Code[10])
        {
            // TableRelation = "Reason Code" WHERE("Order Type" = FILTER(Quote | "Stock Status"));////TODO:

            trigger OnValidate();
            begin
                /*//TODO:
                if ReasonCode.GET("Reason Code") and (ReasonCode.type = ReasonCode.Type::"Lost Opportunity") then begin
                    "Lost Opportunity" := true;
                    "Lost Opportunity Description" := ReasonCode.Description; //TOP230 KT ABCSI CRP 2 Fixes 06022015
                end else
                    CLEAR("Lost Opportunity");
                *///TODO:
            end;
        }
        field(50028; "Reason Code Comment"; Text[60])
        {
        }
        field(50029; "Lost Opportunity Description"; Text[50])
        {
        }
        field(50030; "Medium Unit Price"; Decimal)
        {
            AutoFormatType = 2;
        }
        field(50031; "Last Price User ID"; Code[50])
        {
            Description = 'TOP010E';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50032; "Pre Increase Unit Price"; Decimal)
        {
            Description = 'TPZ2447';
        }
        field(50033; "Post Increase Unit Price"; Decimal)
        {
            Description = 'TPZ2447';
        }
        field(50034; "Special Price"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ2970';
        }
        field(50040; "Blocked Sequence"; Boolean)
        {
            Description = 'TOP130';
        }
        field(50100; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';

            trigger OnLookup();
            begin
                LookupShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(50202; "Recomm. Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Description = 'TOP230';
        }
        field(50206; "Recomm. Multiplier"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            Description = 'TOP230';
            MaxValue = 1;
            MinValue = 0;
        }
        field(50300; "Average Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 4;
            Description = 'TPZ2881';
            Editable = false;

            trigger OnValidate();
            begin
                //MESSAGE('Pankaj');
            end;
        }
        field(51017; "MSRP Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ3090';
        }
        field(51077; "Sorting Order"; Integer)
        {
            Caption = 'Sorting Order';
        }
        field(51078; "Temp Order No."; Code[10])
        {
            Caption = 'Temp Order No.';
        }
        field(51079; "ABC Code"; Code[10])
        {
            Caption = 'ABC Code';
            DataClassification = ToBeClassified;
            Description = 'TPZ2839';
            //TableRelation = "ABC Code";//TODO:
        }
        field(51080; "Item Attribute Value ID"; Integer)
        {
            CalcFormula = Lookup("Item Attribute Value Mapping"."Item Attribute Value ID" WHERE("Table ID" = FILTER(27),
                                                                                                 "No." = FIELD("Item No."),
                                                                                                 "Item Attribute ID" = FILTER(1)));
            Description = 'TPZ2859';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Item No.")
        {
        }
        key(Key2; "Blocked Sequence")
        {
        }
        key(Key3; "Sorting Order")
        {
        }
        key(Key4; "Vendor Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SRSetup: Record "Sales & Receivables Setup";
        ReasonCode: Record "Reason Code";
        "****ABCSI Globals****": Integer;
        DimMgt: Codeunit DimensionManagement;


    procedure UpDateLostOpportunity("Order Type": Option Quote,"Order","Stock Status"; var "Order No.": Code[20]; "LineNo.": Integer; WorkSheet: Record "Quick Quote Worksheet Line"; LocationCode: Code[10]);
    var
        LostOpporunity: Record "Lost Opportunity";
        NoSeriesMgr: Codeunit NoSeriesManagement;
        UOMMgt: Codeunit "Unit of Measure Management";
        Item: Record Item;
        "LostNo.": Code[10];
        QperUOM: Decimal;
    begin
        if "Order No." = '' then begin
            SRSetup.GET;
            SRSetup.TESTFIELD("Lost Opportunity Nos.");
            EVALUATE("LostNo.", SRSetup."Lost Opportunity Nos.");
            NoSeriesMgr.InitSeries("LostNo.", SRSetup."Lost Opportunity Nos.", TODAY, "Order No.", "LostNo.");
        end;
        if not LostOpporunity.GET("Order Type", "Order No.", "LineNo.") then begin
            LostOpporunity.INIT;
            LostOpporunity."Document Type" := "Order Type";
            LostOpporunity."Document No." := "Order No.";
            LostOpporunity."Line No." := "LineNo.";
            LostOpporunity.INSERT;
        end;
        if Item.GET(WorkSheet."Item No.") then
            QperUOM := UOMMgt.GetQtyPerUnitOfMeasure(Item, WorkSheet."Last Price UOM")
        else
            QperUOM := 1;
        LostOpporunity."Sell-to Customer No." := WorkSheet."Sell-To Customer No.";
        LostOpporunity.Type := LostOpporunity.Type::Item;
        LostOpporunity."No." := WorkSheet."Item No.";
        LostOpporunity."Location Code" := LocationCode;
        LostOpporunity."Shipment Date" := TODAY;
        LostOpporunity."Lost Date" := TODAY;
        LostOpporunity."Unit of Measure Code" := WorkSheet."Current UOM";
        LostOpporunity.Quantity := WorkSheet."Current Qty.";
        LostOpporunity."Quantity(Base)" := WorkSheet."Current Qty." * QperUOM;
        LostOpporunity."Actual Unit Price" := WorkSheet."Last Unit Price";
        LostOpporunity."Reason Code" := WorkSheet."Reason Code";
        LostOpporunity."Reason Code Comment" := WorkSheet."Reason Code Comment";
        LostOpporunity."User ID" := USERID;
        LostOpporunity.MODIFY;
    end;

    procedure "****ABCSI Functions****"();
    begin
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin

        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
    end;
}

