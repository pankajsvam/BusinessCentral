tableextension 50200 "TPZItem" extends Item
{
    // version NAVW111.00.00.42633,NAVNA11.00.00.42633,SE0.60.18,SCW19.2.0,UBP2.97,TOP010,050,020,100B,130,230,UBP2.97,WMDM1.6.9,2477,001,3090,3021,3125,005

    fields
    {
        field(50000; "Qty. on Pick"; Decimal)
        {
            CalcFormula = Sum("Warehouse Activity Line"."Qty. Outstanding (Base)" WHERE("Activity Type" = CONST(Pick),
                                                                                         "Item No." = FIELD("No."),
                                                                                         "Variant Code" = FIELD("Variant Filter"),
                                                                                         "Location Code" = FIELD("Location Filter"),
                                                                                         "Due Date" = FIELD("Date Filter"),
                                                                                         "Action Type" = FILTER(" " | Take),
                                                                                         "Breakbulk No." = CONST(0)));
            Caption = 'Qty. on Pick';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Blocked Sequence"; Boolean)
        {
            Caption = 'Blocked Sequence';
            Description = 'TOP130';
        }
        field(50002; "Low Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Low Unit Price';
            Description = 'TOP230';
        }
        field(50003; "High Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'High Unit Price';
            Description = 'TOP230';

            trigger OnValidate();
            begin
                "MSRP Price" := "High Unit Price" * 1.6;//TPZ3021
            end;
        }
        field(50004; "Medium Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Clearance Price';
            Description = 'TOP230,TPZ3168';
        }
        field(50005; "Mandatory Fields Checked"; Boolean)
        {
            Description = 'TPZ989';
        }
        field(50008; Inspection; Boolean)
        {
            Caption = 'Inspection';
            Description = 'TPZ630 TM 081715';
        }
        field(50010; "Qty. in Bin (Base)"; Decimal)
        {
            CalcFormula = Sum("Warehouse Entry"."Qty. (Base)" WHERE("Item No." = FIELD("No."),
                                                                     "Location Code" = FIELD("Location Filter"),
                                                                     "Variant Code" = FIELD("Variant Filter"),
                                                                     "Bin Code" = FIELD("Bin Filter")));
            Description = 'TPZ1675';
            FieldClass = FlowField;
        }
        field(50011; "Prior Generation"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ2783';
            TableRelation = Item;
        }
        field(50012; "Next Generation"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ2783';
            TableRelation = Item;
        }
        field(50030; "Price Book Code"; Code[10])
        {
            Caption = 'Price Book Code';
            Description = 'TOP100B';
            //TableRelation = "Price Book";//TODO:
        }
        field(50200; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Description = 'TOP020';

            trigger OnLookup();
            begin
                //<TPZ2484>
                //<TPZ2477>
                //LookupShortcutDimCode(5,"Shortcut Dimension 5 Code"); //TOP140 KT ABCSI Modification to Payment Terms 01222015
                //EventPublishers.OnLookupShortcutDimCode(5, "Shortcut Dimension 5 Code", Rec);//TODO:
                //</TPZ2477>
                //</TPZ2484>
            end;

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");

                //TOP130 KT ABCSI Item List Sort and Filter by Status 04102015
                if "Shortcut Dimension 5 Code" <> xRec."Shortcut Dimension 5 Code" then
                    if StockStatusWkshLine.GET("No.") then begin
                        StockStatusWkshLine."Shortcut Dimension 5 Code" := "Shortcut Dimension 5 Code";
                        StockStatusWkshLine.MODIFY;
                    end;
                //TOP130 KT ABCSI Item List Sort and Filter by Status 04102015
            end;
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
        field(50301; "Replacement Cost"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 4;
            Description = 'TPZ3125';

            trigger OnValidate();
            begin
                "Replacement Cost Date" := TODAY;
            end;
        }
        field(50302; "Replacement Cost Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ3125';
            Editable = false;
        }
        field(50390; "Blocked Reason Code"; Code[10])
        {
            Caption = 'Blocked Reason Code';
            Description = 'TOP050';
            TableRelation = "Reason Code";
        }
        field(50400; "Alt. Base Unit of Measure"; Code[10])
        {
            Caption = 'Alt. Base Unit of Measure';
            Description = 'TOP050';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(50401; "Alt. Sales Unit of Measure"; Code[10])
        {
            Caption = 'Alt. Sales Unit of Measure';
            Description = 'TOP050';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(50402; "Alt. Purch. Unit of Measure"; Code[10])
        {
            Caption = 'Alt. Purch. Unit of Measure';
            Description = 'TOP050';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(51002; "Last Modified by User ID"; Code[50])
        {
            Caption = 'Last Modified by User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(51003; "Date Created"; Date)
        {
            Caption = 'Date Created';
            Editable = false;
        }
        field(51005; "Created by User ID"; Code[50])
        {
            Caption = 'Created by User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(51006; "WebShop Title"; Text[50])
        {
            Description = 'TPZSANA061316 //EB';
        }
        field(51007; "WebShop SpecSheet Link"; Text[200])
        {
            Description = 'TPZSANA061316 //EB';
        }
        field(51008; "WebShop Item Category Code"; Code[10])
        {
            CaptionML = ENU = 'WebShop Item Category Code',
                        ESM = 'CÙd. categorÙa producto',
                        FRC = 'Code catÙgorie',
                        ENC = 'Item Category Code';
            Description = 'TPZSANA061316 //EB';
            TableRelation = "Item Category";

            trigger OnValidate();
            begin
                if "Item Category Code" <> xRec."Item Category Code" then begin
                    if ItemCategory.GET("Item Category Code") then begin
                        /*IF "Gen. Prod. Posting Group" = '' THEN
                          VALIDATE("Gen. Prod. Posting Group",ItemCategory."Def. Gen. Prod. Posting Group");
                        IF ("VAT Prod. Posting Group" = '') OR
                           (GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") AND
                            ("Gen. Prod. Posting Group" = ItemCategory."Def. Gen. Prod. Posting Group") AND
                            ("VAT Prod. Posting Group" = GenProdPostingGrp."Def. VAT Prod. Posting Group"))
                        THEN
                          VALIDATE("VAT Prod. Posting Group",ItemCategory."Def. VAT Prod. Posting Group");
                        IF "Inventory Posting Group" = '' THEN
                          VALIDATE("Inventory Posting Group",ItemCategory."Def. Inventory Posting Group");
                        IF "Tax Group Code" = '' THEN
                          VALIDATE("Tax Group Code",ItemCategory."Def. Tax Group Code");
                        VALIDATE("Costing Method",ItemCategory."Def. Costing Method");
                        */// EB 2017
                    end;
                    /*
                    if not ProductGrp.GET("Item Category Code", "Product Group Code") then
                        VALIDATE("Product Group Code", '')
                    else
                        VALIDATE("Product Group Code");
                    *///TODO:
                    //TOP010 KT ABCSI Stock Status Quick Quote Screen - 01132015
                    if StockStatusWkshLine.GET("No.") then begin
                        StockStatusWkshLine."Item Category Code" := "Item Category Code";
                        StockStatusWkshLine.MODIFY;
                    end;
                    //TOP010 KT ABCSI Stock Status Quick Quote Screen - 01132015

                end;

            end;
        }
        field(51009; "WebShop Product Group Code"; Code[10])
        {
            CaptionML = ENU = 'WebShop Product Group Code',
                        ESM = 'CÙd. grupo producto',
                        FRC = 'Code groupe produits',
                        ENC = 'Product Group Code';
            Description = 'TPZSANA061316 //EB';
            TableRelation = "Product Group".Code WHERE("Item Category Code" = FIELD("WebShop Item Category Code"));

            trigger OnValidate();
            begin
                //TOP010 KT ABCSI Stock Status Quick Quote Screen - 01132015
                /*
                if "Product Group Code" <> xRec."Product Group Code" then
                    if StockStatusWkshLine.GET("No.") then begin
                        StockStatusWkshLine."Product Group Code" := "Product Group Code";
                        StockStatusWkshLine.MODIFY;
                    end;
                *///TODO:
                //TOP010 KT ABCSI Stock Status Quick Quote Screen - 01132015
            end;
        }
        field(51010; "WebShop SellSheet Link"; Text[200])
        {
            Description = 'TPZSANA061316 //EB';
        }
        field(51011; "WebShop Order Minimum"; Decimal)
        {
            Description = 'TPZ1600';
        }
        field(51012; "WebShop Order Multiple"; Decimal)
        {
            Description = 'TPZ1600';
        }
        field(51013; "WebShop Gross Weight Per Pack"; Decimal)
        {
            Description = 'TPZ1600';
        }
        field(51014; "WebShop Length"; Decimal)
        {
            Description = 'TPZ1600';
        }
        field(51015; "WebShop Width"; Decimal)
        {
            Description = 'TPZ1600';
        }
        field(51016; "WebShop Height"; Decimal)
        {
            Description = 'TPZ1600';
        }
        field(51017; "IMAP Price"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            Description = 'TPZ3090';
        }
        field(51018; "MSRP Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ3021';
        }
        field(51077; "Sorting Order"; Integer)
        {
            Caption = 'Sorting Order';
        }
        field(51078; "Sales Order Multiple"; Decimal)
        {
            Caption = 'Sales Order Multiple';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(51400; Hot; Boolean)
        {
            Caption = 'Hot';
        }
        field(51401; "ABC Code"; Code[10])
        {
            Caption = 'ABC Code';
            //TableRelation = "ABC Code";//TODO:

            trigger OnValidate();
            begin
                //<TPZ2839>
                if "ABC Code" <> xRec."ABC Code" then
                    if StockStatusWkshLine.GET("No.") then begin
                        StockStatusWkshLine."ABC Code" := "ABC Code";
                        StockStatusWkshLine.MODIFY;
                    end;
                //</TPZ2839>
            end;
        }
        field(51470; Oversize; Boolean)
        {
            Caption = 'Oversize';
        }
        field(51490; "Label Description"; Text[60])
        {
            Caption = 'Label Description';
        }
        field(51491; "Label Description 2"; Text[60])
        {
            Caption = 'Label Description 2';
        }
        field(51492; "Label Description 3"; Text[60])
        {
            Caption = 'Label Description 3';
        }
        field(51493; "Label Description 4"; Text[60])
        {
            Caption = 'Label Description 4';
        }
        field(51494; Size; Code[20])
        {
            Caption = 'Size';
        }
        field(51700; "SupplyHouse.com"; Boolean)
        {
            Caption = 'SupplyHouse.com';
        }
        field(51701; "Picture grouping Item Number"; Code[20])
        {
            Caption = 'Picture grouping Item Number';
            DataClassification = ToBeClassified;
            Description = 'TPZ2534';
        }
        field(51702; "Monthly Demand"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ2590';
        }
        field(51703; "Long Term Product Title"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ2672';
        }
        field(51704; "Short Term Product Title"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ2672';
        }
        field(51705; "Override Sales Order Multiple"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ2899';
        }
        field(70551; "Procurement Unit Exists"; Boolean)
        {
            //CalcFormula = Exist("Procurement Unit" WHERE("Item No." = FIELD("No.")));//TODO:
            Caption = 'Procurement Unit Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70552; "Summary Code 1"; Code[20])
        {
            Caption = 'Summary Code 1';
            //TableRelation = "Item Summary Code".Code WHERE(Type = CONST("Code 1"));//TODO:
        }
        field(70553; "Summary Code 2"; Code[20])
        {
            Caption = 'Summary Code 2';
            //TableRelation = "Item Summary Code".Code WHERE(Type = CONST("Code 2"));//TODO:
        }
        field(70554; "Summary Code 3"; Code[20])
        {
            Caption = 'Summary Code 3';
            //TableRelation = "Item Summary Code".Code WHERE(Type = CONST("Code 3"));//TODO:
        }
        field(70555; "Item UID"; Integer)
        {
            Caption = 'Item UID';
        }
        field(11123302; "Visible in Webshop"; Boolean)
        {
            Caption = 'Visible in Webshop';
        }
        field(11123304; "Last Date/Time Modified"; DateTime)
        {
            Caption = 'Last Date/Time Modified';
            Editable = false;
        }
        field(14000601; "Receive Rule Code"; Code[10])
        {
            Caption = 'Receive Rule Code';
            //TableRelation = "Receive Rule";//TODO:
        }
        field(14000701; "Export License Required"; Boolean)
        {
            Caption = 'Export License Required';
        }
        field(14000703; "Dimmed Weight"; Decimal)
        {
            BlankZero = true;
            Caption = 'Dimmed Weight';
            DecimalPlaces = 0 : 5;
        }
        field(14000704; "Std. Pack Unit of Measure Code"; Code[10])
        {
            Caption = 'Std. Pack Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(14000705; "Std. Packs per Package"; Integer)
        {
            Caption = 'Std. Packs per Package';
        }
        field(14000708; "Always Enter Quantity"; Boolean)
        {
            Caption = 'Always Enter Quantity';
        }
        field(14000709; "Schedule B Code"; Code[10])
        {
            Caption = 'Schedule B Code';
            //TableRelation = "Schedule B Code".Code;//TODO:

            trigger OnValidate();
            var
            //ScheduleBCode: Record "Schedule B Code";//TODO:
            begin
                if "Schedule B Code" = '' then begin
                    "Schedule B Unit of Measure 1" := '';
                    "Schedule B Unit of Measure 2" := '';
                    "Schedule B Quantity 1" := 0;
                    "Schedule B Quantity 2" := 0;
                end else begin
                    /*
                    ScheduleBCode.GET("Schedule B Code");
                    "Schedule B Unit of Measure 1" := ScheduleBCode."Unit of Measure 1";
                    "Schedule B Unit of Measure 2" := ScheduleBCode."Unit of Measure 2";
                    *///TODO:
                end;
            end;
        }
        field(14000712; "Quantity Packed"; Decimal)
        {
            //CalcFormula = Sum("Package Line"."Quantity (Base)" WHERE(Type = CONST(Item),
            //"No." = FIELD("No.")));//TODO:
            Caption = 'Quantity Packed';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(14000716; "E-Ship Tracking Code"; Code[10])
        {
            Caption = 'E-Ship Tracking Code';
            //TableRelation = "E-Ship Tracking Code";//TODO:
        }
        field(14000717; "Schedule B Quantity 1"; Decimal)
        {
            Caption = 'Schedule B Quantity 1';
            DecimalPlaces = 0 : 5;
        }
        field(14000718; "Schedule B Unit of Measure 1"; Code[10])
        {
            Caption = 'Schedule B Unit of Measure 1';
            //TableRelation = "Schedule B Unit of Measure".Code;//TODO:
        }
        field(14000719; "Schedule B Quantity 2"; Decimal)
        {
            Caption = 'Schedule B Quantity 2';
            DecimalPlaces = 0 : 5;
        }
        field(14000720; "Schedule B Unit of Measure 2"; Code[10])
        {
            Caption = 'Schedule B Unit of Measure 2';
            //TableRelation = "Schedule B Unit of Measure".Code;//TODO:
        }
        field(14000721; "Use Unit of Measure Dimensions"; Boolean)
        {
            Caption = 'Use Unit of Measure Dimensions';
        }
        field(14000722; "NMFC Code"; Code[10])
        {
            Caption = 'NMFC Code';
            //TableRelation = "LTL Freight NMFC Code";//TODO:
        }
        field(14000761; "Certificate of Origin No."; Code[10])
        {
            Caption = 'Certificate of Origin No.';
        }
        field(14000762; "Goods Not In Free Circulation"; Boolean)
        {
            Caption = 'Goods Not In Free Circulation';
        }
        field(14000782; "Export Control Class No."; Code[15])
        {
            Caption = 'Export Control Class No.';
            //TableRelation = "Export Controls Class Number";//TODO:
        }
        field(14000783; "Preference Criteria"; Option)
        {
            Caption = 'Preference Criteria';
            OptionCaption = '" ,A,B,C,D,E,F"';
            OptionMembers = " ",A,B,C,D,E,F;
        }
        field(14000784; "Producer of Good Indicator"; Option)
        {
            Caption = 'Producer of Good Indicator';
            OptionCaption = '" ,YES,1,2,3"';
            OptionMembers = " ",YES,"1","2","3";
        }
        field(14000785; "RVC in Net Cost Method"; Boolean)
        {
            Caption = 'RVC in Net Cost Method';
        }
        field(14000801; "LTL Freight Type"; Code[10])
        {
            Caption = 'LTL Freight Type';
            //TableRelation = "LTL Freight Type";//TODO:
        }
        field(14000821; "Item UPC/EAN Number"; Code[20])
        {
            Caption = 'Item UPC/EAN Number';
        }
        field(14050001; "UPS ISC Type"; Option)
        {
            Caption = 'UPS ISC Type';
            OptionCaption = '" ,Seeds,Perishables,Tobacco,Plants,Alcoholic Beverages,Biological Substance,Special Exceptions"';
            OptionMembers = " ",Seeds,Perishables,Tobacco,Plants,"Alcoholic Beverages","Biological Substance","Special Exceptions";
        }
    }
    keys
    {
        /*
        key(Key1; "No. 2")
        {
        }
        *///TODO:
        key(Key2; "Item UPC/EAN Number")
        {
        }
        // key(Key3; "Visible in Webshop", "Item Category Code", "Product Group Code");//TODO:

        key(Key4; "Sorting Order")
        {
        }
        key(Key5; "Blocked Sequence")
        {
        }
        //key(Key6; Blocked)//TODO:

        key(Key7; "Blocked Reason Code")
        {
        }
        //key(Key8; "Vendor Item No.")//TODO:

    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
    //ItemUsage: Record "Item Usage";//TODO:
    //ProcUnit: Record "Procurement Unit";//TODO:
    //UsageLedgerEntry: Record "Usage Ledger Entry";//TODO:
    //UsageRedirect: Record "Usage Redirect";//TODO:

    var
        Text14000701: Label '%1 is normally 12 digit, use this number anyway?';
        Text14000702: Label 'Nothing Changed.';
        "****ABCSI Globals****": Integer;
        StockStatusWkshLine: Record "Stock Status Wksh. Line";
        Text11123302: Label 'You have changed the %1 field value of the %2 %3.\\Do you want to update visibility of its variants?';
        Text14000551: Label 'AFP Item Usage Redirects must be removed before deleting this item.';
        //EventPublishers: Codeunit EventPublishers;//TODO:
        ItemCategory: Record "Item Category";
    //ProductGrp: Record "Product Group";//TODO:
}

