page 50203 "Stock Status Worksheet"
{
    Caption = 'Stock Status Worksheet new';
    // version TPZ000.00.00,003,TPZ2970,TPZ3090

    // TOP010 KT ABCSI Stock Status Quick Quote Screen 12082014
    //  - Created this page and Functions related to Stock Status Quick Quote
    // 
    // TOP170 KT ABCSI Sales Order Updates 04022015
    //   - Added code to the NewOrderQuote function
    // 
    // TOP130 KT ABCSI Item List Sort and Filter by Status 04172015
    //   - Added a new field "Blocked Sequence"
    //   - Added code to filter the records in Refresh() functions
    //   - Made Blocked field non editable
    //   - Added code in the NewOrderQuote function to pass the Shortcut Dimension 5 Code to the Sales Quote or Sales Order
    //   - Checked for Blocked field when entering values into Current Qty. and other required fields
    // 
    // TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
    //   - Added code to set the key for Last Unit Price fields
    // 
    // TOP230 KT ABCSI CRP 2 Fixes 07152015
    //   - Added a lookup functionality to "Qty. on Purch. Order" field
    //   - Added code in UpdateLine and UpdateSingleLine functions to update the Low Unit Price, High Unit Price and Medium Unit Price
    //   - Added a new field "Lost Opportunity Description"
    //   - Added Go Home Action to move to the first record
    // 
    // TOP010 KT ABCSI Stock Status Quick Quote 06042015
    //   - Added an error message in NewOrderQuote function to prevent creating Sales Order/Quote with Curr. Qty. = 0
    //   - Updated the default Sorting of the page in the SourceTableView property
    // 
    // TOP010B KT ABCSI SSQQ Division Code 07092015
    //   - Created a new function UserPrompt for checking the curr. qty field
    // 
    // TOP10C KT ABCSI - SSQQ Item Search 07082015
    //   - Added a function FindItemNo
    // 
    // TOP010D KT ABCSI SSQQ Unit Price 07142015
    //   - Added code in UpdateLine function to update the Unit Price and Recomm. Unit Price
    // 
    // TOP10E KT ABCSI - Additional Stock Status 07282015
    //   - Added a function FindVendItemNo
    //   - Added a new field 'Last Price User ID' and the code to populate the field
    // 
    // 2015-06-19 TPZ591 VCHERNYA
    //   Sorting Order field has been added
    //   Sorting has been changed to Sorting Order field
    // 2015-06-30 TPZ449 VCHERNYA
    //   Last Prices and Country/Region Last Prices page actions have been added
    //   Population of Division Code (Shortcut Dimension 5 Code) and Country/Region Code in Last Sales Price table has been added
    // 2015-07-01 TPZ835 VCHERNYA
    //   Comments page action has been added
    // 2015-07-13 TPZ820 VCHERNYA
    //   GetItemNo function has been added
    // 2015-09-25 TPZ1046 VCHERNYA
    //   BlankZero property set to Yes for Current Qty. column
    // 2015-10-06 TPZ1055 VCHERNYA
    //   FilterByItemDescription and FilterByItemDescription2 functions have been added
    // 
    // TOP010 - Stock Status Quick Quote Screen - KT ABCSI 11052015
    //   - Added the function CalcQtyOnPick, added code on OnDrillDown trigger of Qty. on Pick Loc. and Qty. Avail. to Pick fields
    //   - Changed the properties of Qty. On Pick, Qty. Avail. to Pick fields
    // 
    // 2016-03-24 TPZ1519 TAKHMETO
    //   Page Action Ledger Entries has been added
    // 2016-04-01 TPZ1014 TAKHMETO
    //   Validation of Customer No. in Last Sales Price has been added
    // 2016-07-08 TPZ1545 EBAGIM
    //   Color Coding based on blocked item attributes
    // 2016-09-27 TPZ1697 EBAGIM
    //   Assign location code based on Ship-to Division
    // 2017-02-17 TPZ1801 EBAGIM
    //   Filter out blocked items by default
    // 
    // 2018.11.09 BUG2386 RIS  - revamp code to eliminate error failures
    // 2018-12-27 SQLPerform AKB
    //   Revised function UpdateLine() to add SETCURRENTKEY statements, and missing filter statements
    // 2019-05-03 TPZ2531 Uchouhan
    //   Removed NPI Blocked option and added code for dimension code 'Intro';
    // 2019-06-28 TPZ2590 UCHOUHAN
    //   Added Month of Stock feild.
    // 2019-07-12 TPZ2482 UCHOUHAN
    //   Changes for OverWrap Sevice Item.
    // 2019-10-23 TPZ2651 VAHAMAD
    //   Code added in Function UpdateLine
    // 2019-11-26 TPZ2718 UCHOUHAN
    //   Change Blankzero Property to YES for 'Month of Stock' Field.
    // 2019-12-04 TPZ2729 RTIWARI
    //   Code added to ignore Return Order/Credit Memo while updating Last Sales Price
    // 2020-05-13 TPZ2839 UCHOUHAN
    //   Added "ABC Code" field.
    //   Added code for filter out 'OB' ABC Code.
    // 2020-05-13 TPZ2788 UCHOUHAN
    //   Added code to change color coding according to  ABC Code.
    // TPZ2785 05112020 GGUPTA Remove Item blocking Topaz Customization
    // TPZ2859 05192020 RSAH
    //   - Filter Item by attribute on the stock status screen
    // 001 TPZ2881 PKS 07232020  Added new fields Average Unit Cost and Gross Margin % Avg Cost
    // 002 TPZ2970 VAH 11252020 Added code in functions : FetchRecommFieldValues,UpdateLastSalesPrice,NewOrderQuote,UpdateLine
    //     Added Field : Special Price
    // 003 TPZ3090 VAH 02222020 Added new field "MSRP Price"

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Stock Status Wksh. Line";
    SourceTableView = SORTING("Sorting Order")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                Visible = false;
                field(xItemNo; xItemNo)
                {
                    Caption = 'ItemNoFilter';

                    trigger OnValidate();
                    var
                        icnt: Integer;
                        sItemNo: Code[20];
                        wrk: Record "Stock Status Wksh. Line";
                        sDimCode: Code[10];
                    begin
                        xItemNo := UPPERCASE(xItemNo);

                        wrk.SETCURRENTKEY("Item No.");
                        wrk.SETRANGE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");
                        //wrk.SETFILTER(Blocked, '<>All');  //gg item blocking TPZ2785
                        wrk.SETRANGE(Blocked, false);//TPZ2785
                        //wrk.SETFILTER("Item No.",xItemNo + '*');
                        wrk.SETRANGE("ABC Code", '<>OB'); //<TPZ2839>
                        icnt := 0;
                        if wrk.FINDFIRST then begin
                            repeat
                                icnt := icnt + 1;
                                if xItemNo = COPYSTR(wrk."Item No.", 1, STRLEN(xItemNo)) then begin
                                    sItemNo := wrk."Item No.";
                                    wrk.FINDLAST;
                                end;
                            until wrk.NEXT = 0;
                        end;
                        //MESSAGE(sItemNo + ' ' + FORMAT(icnt));
                        SETFILTER("Item No.", sItemNo);
                        FINDFIRST;

                        CurrPage.UPDATE(false);
                        CurrPage.ACTIVATE(true);
                        if CURRENTCLIENTTYPE = CLIENTTYPE::Windows then begin
                            /*if ISCLEAR(WSHSHELL) then
                              CREATE(WSHSHELL, true, true);
                            WSHSHELL.SendKeys('{F5}');*///VAH
                        end;
                    end;
                }
                field(xVendorNo; xVendorItemNo)
                {
                    Caption = 'VendorNoFilter';

                    trigger OnValidate();
                    var
                        icnt: Integer;
                        sItemNo: Code[20];
                        wrk: Record "Stock Status Wksh. Line";
                    begin
                        xVendorItemNo := UPPERCASE(xVendorItemNo);
                        wrk.SETCURRENTKEY("Vendor Item No.");
                        wrk.SETRANGE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");
                        //wrk.SETFILTER(Blocked, '<>All');  //gg item blocking TPZ2785
                        wrk.SETRANGE(Blocked, false);//TPZ2785
                        //wrk.SETFILTER("Item No.",xVendorItemNo + '*');
                        wrk.SETRANGE("ABC Code", '<>OB'); //<TPZ2839>
                        icnt := 0;
                        if wrk.FINDFIRST then begin
                            repeat
                                icnt := icnt + 1;
                                if xVendorItemNo = COPYSTR(wrk."Vendor Item No.", 1, STRLEN(xVendorItemNo)) then begin
                                    sItemNo := wrk."Vendor Item No.";
                                    wrk.FINDLAST;
                                end;
                            until wrk.NEXT = 0;
                        end;
                        //MESSAGE(sItemNo + ' ' + FORMAT(icnt));
                        SETFILTER("Vendor Item No.", sItemNo);
                        FINDFIRST;

                        CurrPage.UPDATE(false);
                        CurrPage.ACTIVATE(true);
                        if CURRENTCLIENTTYPE = CLIENTTYPE::Windows then begin
                            /*if ISCLEAR(WSHSHELL) then
                              CREATE(WSHSHELL, true, true);
                            WSHSHELL.SendKeys('{F5}');*/ //VAH
                        end;
                    end;
                }
            }
            repeater(Group)
            {
                field(Blocked; Blocked)
                {
                    Editable = false;
                    HideValue = ESACC_F54_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F54_Visible;
                }
                field("Blocked Sequence"; "Blocked Sequence")
                {
                    Editable = false;
                    HideValue = ESACC_F50040_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F50040_Visible;
                }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code")
                {
                    Editable = false;
                    Enabled = ESACC_F50100_Editable;
                    HideValue = ESACC_F50100_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F50100_Visible;
                }
                field("Item No."; "Item No.")
                {
                    Editable = false;
                    HideValue = ESACC_F6_HideValue;
                    QuickEntry = false;
                    StyleExpr = StyleTxtABC;
                    Visible = ESACC_F6_Visible;
                    Width = 20;
                }
                field(Description; Description)
                {
                    Editable = false;
                    HideValue = ESACC_F11_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F11_Visible;
                }
                field("Description 2"; rec."Description 2")
                {
                    Editable = false;
                    HideValue = ESACC_F12_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F12_Visible;
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                    Editable = false;
                    HideValue = ESACC_F8_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F8_Visible;
                }
                field("Item Category Code"; "Item Category Code")
                {
                    Editable = false;
                    HideValue = ESACC_F5709_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F5709_Visible;
                }
                field("Product Group Code"; "Product Group Code")
                {
                    Editable = false;
                    HideValue = ESACC_F5712_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F5712_Visible;
                }
                field("Country/Region of Origin Code"; "Country/Region of Origin Code")
                {
                    Editable = false;
                    HideValue = ESACC_F95_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F95_Visible;
                }
                field("Manufacturer Code"; "Manufacturer Code")
                {
                    Editable = false;
                    HideValue = ESACC_F5701_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F5701_Visible;
                }
                field("ABC Code"; "ABC Code")
                {
                    Editable = false;
                    QuickEntry = false;
                    StyleExpr = StyleTxtABC;
                }
                field("Quantity Available on Location"; "Quantity Available on Location")
                {
                    Editable = false;
                    HideValue = ESACC_F50000_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F50000_Visible;
                }
                field("Main Loc. Qty. Avail"; "Main Loc. Qty. Avail")
                {
                    Editable = false;
                    HideValue = ESACC_F50001_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F50001_Visible;
                }
                /*     field(MonthsofStock; StockStatusQuickQuoteMgt.CalcMonthOfStock(Rec))
                    {
                        Caption = 'Months of Stock';
                    } */
                field("Order Date"; "Order Date")
                {
                    Editable = ESACC_F19_Editable;
                    HideValue = ESACC_F19_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F19_Visible;
                }
                field("Location Code"; "Location Code")
                {
                    Editable = ESACC_F7_Editable;
                    HideValue = ESACC_F7_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F7_Visible;

                    trigger OnValidate();
                    var
                        "Count": Integer;
                    begin
                        if (Blocked = true) then //OR (Blocked = Blocked::Sale) THEN <TPZ1545> TPZ2785
                            FIELDERROR(Blocked);

                        if "Location Code" <> xRec."Location Code" then begin
                            CLEAR(Count);
                            QuickQuoteWorkSheet.RESET;
                            if QuickQuoteWorkSheet.FIND('-') then
                                repeat
                                    if QuickQuoteWorkSheet."Item No." = "Item No." then Count += 1;
                                until QuickQuoteWorkSheet.NEXT = 0;
                            if Count = 1 then begin
                                QuickQuoteWorkSheet.RESET;
                                QuickQuoteWorkSheet.SETCURRENTKEY("Item No.", Description);
                                QuickQuoteWorkSheet.SETRANGE("Item No.", "Item No.");
                                if QuickQuoteWorkSheet.FIND('-') then begin
                                    QuickQuoteWorkSheet."Location Code" := "Location Code";
                                    QuickQuoteWorkSheet.MODIFY;
                                end;
                            end;
                        end;

                        UpdateSingleLine("Location Code");
                    end;
                }
                field("Current Qty."; "Current Qty.")
                {
                    BlankZero = true;
                    Editable = ESACC_F50005_Editable;
                    HideValue = ESACC_F50005_HideValue;
                    Visible = ESACC_F50005_Visible;

                    trigger OnValidate();
                    begin
                        if (Blocked = true) then //TPZ2785
                            FIELDERROR(Blocked);


                        if "Current Qty." <> 0 then begin
                            UpdateLastSalesPrice(Rec);
                            FetchRecommFieldValues("Item No.", InCustFilter); //TOP230 KT ABCSI CRP 2 Fixes 05282015
                            if not StockStatusQuickQuote.GET("Item No.") then begin
                                StockStatusQuickQuote.INIT;
                                StockStatusQuickQuote.TRANSFERFIELDS(Rec);
                                StockStatusQuickQuote."Sell-to Customer No." := InCustFilter;
                                StockStatusQuickQuote."Location Code" := "Location Code";
                                StockStatusQuickQuote."Unit Price" := "Unit Price";
                                StockStatusQuickQuote."Recomm. Unit Price" := "Recomm. Unit Price"; //TOP230 KT ABCSI CRP 2 Fixes 05282015
                                StockStatusQuickQuote."Current Qty." := "Current Qty.";
                                StockStatusQuickQuote."Current UOM" := "Current UOM";
                                StockStatusQuickQuote.INSERT;
                                QuickQuoteWorkSheet.TRANSFERFIELDS(StockStatusQuickQuote);
                                LineNo += 1;
                                QuickQuoteWorkSheet."Line No." := LineNo;
                                if ItemUOM.GET("Item No.", "Current UOM") then
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := ItemUOM."Qty. per Unit of Measure"
                                else
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := 1;
                                QuickQuoteWorkSheet."Current Qty (Base)" := QuickQuoteWorkSheet."Qty per Unit of Measure" * "Current Qty.";
                                QuickQuoteWorkSheet.INSERT;
                                //LineNo := LineNo +1;
                            end
                            else begin
                                StockStatusQuickQuote."Current Qty." := "Current Qty.";
                                StockStatusQuickQuote."Recomm. Unit Price" := "Recomm. Unit Price"; //TOP230 KT ABCSI CRP 2 Fixes 05282015
                                StockStatusQuickQuote.MODIFY;
                                QuickQuoteWorkSheet.RESET;
                                QuickQuoteWorkSheet.SETRANGE("Item No.", "Item No.");
                                if QuickQuoteWorkSheet.FIND('+') then begin
                                    OldLineNo := QuickQuoteWorkSheet."Line No.";
                                    //LineNo := QuickQuoteWorkSheet."Line No." + 1;
                                end else begin
                                    QuickQuoteWorkSheet.RESET;
                                    if QuickQuoteWorkSheet.FIND('+') then LineNo := QuickQuoteWorkSheet."Line No.";
                                    OldLineNo := LineNo;
                                    LineNo := LineNo + 1;
                                end;
                                QuickQuoteWorkSheet.TRANSFERFIELDS(StockStatusQuickQuote);
                                QuickQuoteWorkSheet."Line No." := OldLineNo;
                                if ItemUOM.GET("Item No.", "Current UOM") then
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := ItemUOM."Qty. per Unit of Measure"
                                else
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := 1;
                                QuickQuoteWorkSheet."Current Qty (Base)" := QuickQuoteWorkSheet."Qty per Unit of Measure" * "Current Qty.";
                                QuickQuoteWorkSheet."Promotion Code" := "Promotion Code";
                                QuickQuoteWorkSheet.MODIFY;
                            end;
                        end else
                            if StockStatusQuickQuote.GET("Item No.") then
                                if xRec."Current Qty." <> 0 then begin
                                    StockStatusQuickQuote."Current Qty." := "Current Qty.";
                                    StockStatusQuickQuote.MODIFY;
                                    QuickQuoteWorkSheet.RESET;
                                    QuickQuoteWorkSheet.SETRANGE("Item No.", "Item No.");
                                    if QuickQuoteWorkSheet.FIND('+') then begin
                                        OldLineNo := QuickQuoteWorkSheet."Line No.";
                                        //LineNo := QuickQuoteWorkSheet."Line No." + 1;
                                    end else begin
                                        QuickQuoteWorkSheet.RESET;
                                        if QuickQuoteWorkSheet.FIND('+') then LineNo := QuickQuoteWorkSheet."Line No.";
                                        OldLineNo := LineNo;
                                        LineNo := LineNo + 1;
                                    end;
                                    QuickQuoteWorkSheet.TRANSFERFIELDS(StockStatusQuickQuote);
                                    QuickQuoteWorkSheet."Line No." := OldLineNo;
                                    if ItemUOM.GET("Item No.", "Current UOM") then
                                        QuickQuoteWorkSheet."Qty per Unit of Measure" := ItemUOM."Qty. per Unit of Measure"
                                    else
                                        QuickQuoteWorkSheet."Qty per Unit of Measure" := 1;
                                    QuickQuoteWorkSheet."Current Qty (Base)" := QuickQuoteWorkSheet."Qty per Unit of Measure" * "Current Qty.";
                                    QuickQuoteWorkSheet."Promotion Code" := "Promotion Code";
                                    QuickQuoteWorkSheet.MODIFY;
                                end;
                    end;
                }
                field("Unit Price"; "Unit Price")
                {
                    Editable = ESACC_F22_Editable;
                    HideValue = ESACC_F22_HideValue;
                    StyleExpr = StyleTxtNew;
                    Visible = ESACC_F22_Visible;

                    trigger OnValidate();
                    begin
                        if (Blocked = true) then //TPZ2785
                            FIELDERROR(Blocked);
                        //UpdateUnitPrice; //AJAY
                        if "Unit Price" <> 0 then begin
                            UpdateLastSalesPrice(Rec);
                            if not StockStatusQuickQuote.GET("Item No.") then begin
                                StockStatusQuickQuote.INIT;
                                StockStatusQuickQuote.TRANSFERFIELDS(Rec);
                                StockStatusQuickQuote."Sell-to Customer No." := InCustFilter;
                                StockStatusQuickQuote."Location Code" := "Location Code";
                                StockStatusQuickQuote."Unit Price" := "Unit Price";
                                StockStatusQuickQuote."Current Qty." := "Current Qty.";
                                StockStatusQuickQuote."Current UOM" := "Current UOM";
                                StockStatusQuickQuote.INSERT;
                                QuickQuoteWorkSheet.TRANSFERFIELDS(StockStatusQuickQuote);
                                LineNo += 1;
                                QuickQuoteWorkSheet."Line No." := LineNo;
                                //LineNo := LineNo + 1;
                                if ItemUOM.GET("Item No.", "Current UOM") then
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := ItemUOM."Qty. per Unit of Measure"
                                else
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := 1;
                                QuickQuoteWorkSheet."Current Qty (Base)" := QuickQuoteWorkSheet."Qty per Unit of Measure" * "Current Qty.";
                                QuickQuoteWorkSheet.INSERT;
                            end
                            else begin
                                StockStatusQuickQuote."Sell-to Customer No." := InCustFilter;
                                StockStatusQuickQuote."Unit Price" := "Unit Price";
                                StockStatusQuickQuote.MODIFY;
                                QuickQuoteWorkSheet.RESET;
                                QuickQuoteWorkSheet.SETRANGE("Item No.", "Item No.");
                                if QuickQuoteWorkSheet.FIND('+') then begin
                                    OldLineNo := QuickQuoteWorkSheet."Line No.";
                                    //LineNo := QuickQuoteWorkSheet."Line No." + 1;
                                end else begin
                                    QuickQuoteWorkSheet.RESET;
                                    if QuickQuoteWorkSheet.FIND('+') then LineNo := QuickQuoteWorkSheet."Line No.";
                                    OldLineNo := LineNo;
                                    LineNo := LineNo + 1;
                                end;
                                QuickQuoteWorkSheet.TRANSFERFIELDS(StockStatusQuickQuote);
                                QuickQuoteWorkSheet."Line No." := OldLineNo;
                                if ItemUOM.GET("Item No.", "Current UOM") then
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := ItemUOM."Qty. per Unit of Measure"
                                else
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := 1;
                                QuickQuoteWorkSheet."Current Qty (Base)" := QuickQuoteWorkSheet."Qty per Unit of Measure" * "Current Qty.";
                                QuickQuoteWorkSheet.MODIFY;
                            end;
                        end else
                            if StockStatusQuickQuote.GET("Item No.") then
                                if xRec."Current Qty." <> 0 then begin
                                    StockStatusQuickQuote."Current Qty." := "Current Qty.";
                                    StockStatusQuickQuote.MODIFY;
                                    QuickQuoteWorkSheet.RESET;
                                    QuickQuoteWorkSheet.SETRANGE("Item No.", "Item No.");
                                    if QuickQuoteWorkSheet.FIND('+') then begin
                                        OldLineNo := QuickQuoteWorkSheet."Line No.";
                                        //LineNo := QuickQuoteWorkSheet."Line No." + 1;
                                    end else begin
                                        QuickQuoteWorkSheet.RESET;
                                        if QuickQuoteWorkSheet.FIND('+') then LineNo := QuickQuoteWorkSheet."Line No.";
                                        OldLineNo := LineNo;
                                        LineNo := LineNo + 1;
                                    end;
                                    QuickQuoteWorkSheet.TRANSFERFIELDS(StockStatusQuickQuote);
                                    if Customer."Location Code" <> StockStatusQuickQuote."Location Code" then begin
                                        WLoc.GET(StockStatusQuickQuote."Location Code");
                                        //QuickQuoteWorkSheet."Location Code" := WLoc."Location Code";
                                    end;
                                    QuickQuoteWorkSheet."Line No." := OldLineNo;
                                    if ItemUOM.GET("Item No.", "Current UOM") then
                                        QuickQuoteWorkSheet."Qty per Unit of Measure" := ItemUOM."Qty. per Unit of Measure"
                                    else
                                        QuickQuoteWorkSheet."Qty per Unit of Measure" := 1;
                                    QuickQuoteWorkSheet."Current Qty (Base)" := QuickQuoteWorkSheet."Qty per Unit of Measure" * "Current Qty.";
                                    QuickQuoteWorkSheet.MODIFY;
                                end;
                    end;
                }
                field("Recomm. Unit Price"; "Recomm. Unit Price")
                {
                    Editable = false;
                    HideValue = ESACC_F50202_HideValue;
                    Visible = ESACC_F50202_Visible;
                }
                field("Special Price"; "Special Price")
                {
                }
                field("Current UOM"; "Current UOM")
                {
                    Editable = ESACC_F50006_Editable;
                    HideValue = ESACC_F50006_HideValue;
                    Visible = ESACC_F50006_Visible;

                    trigger OnValidate();
                    begin

                        if "Current UOM" <> '' then begin
                            if (CompanyInformation."Location Code" <> '') and (Item3.GET("Item No.")) and
                               ("Current UOM" <> xRec."Current UOM") then begin
                                Item3.SETFILTER("Location Filter", CompanyInformation."Location Code");
                                Item3.CALCFIELDS(Inventory, "Qty. on Sales Order");
                                "Main Loc. Qty. Avail" := (Item3.Inventory - Item3."Qty. on Sales Order") / QtyPerUOM;
                            end;
                            if Item.GET("Item No.") then begin
                                QtyPerUOM := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Current UOM");
                                //Item.SETFILTER("Location Filter",StockStatusQuickQuote.Location);
                                Item.SETRANGE("Location Filter", "Location Code");
                                Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Purch. Order");
                                "Quantity Available on Location" := (Item.Inventory - Item."Qty. on Sales Order") / QtyPerUOM;
                                "Qty. on Hand" := Item.Inventory / QtyPerUOM;
                                "Qty. on Purch. Order" := Item."Qty. on Purch. Order" / QtyPerUOM;
                            end;
                            if "Unit Price" <> 0 then
                                UpdateLastSalesPrice(Rec);

                            if not StockStatusQuickQuote.GET("Item No.") then begin
                                StockStatusQuickQuote.INIT;
                                StockStatusQuickQuote.TRANSFERFIELDS(Rec);
                                StockStatusQuickQuote."Sell-to Customer No." := InCustFilter;
                                StockStatusQuickQuote."Location Code" := "Location Code";
                                StockStatusQuickQuote."Unit Price" := "Unit Price";
                                StockStatusQuickQuote."Current Qty." := "Current Qty.";
                                StockStatusQuickQuote."Current UOM" := "Current UOM";
                                StockStatusQuickQuote.INSERT;
                                QuickQuoteWorkSheet.TRANSFERFIELDS(StockStatusQuickQuote);
                                LineNo += 1;
                                QuickQuoteWorkSheet."Line No." := LineNo;
                                if ItemUOM.GET("Item No.", "Current UOM") then
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := ItemUOM."Qty. per Unit of Measure"
                                else
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := 1;
                                QuickQuoteWorkSheet."Current Qty (Base)" := QuickQuoteWorkSheet."Qty per Unit of Measure" * "Current Qty.";
                                QuickQuoteWorkSheet."Promotion Code" := "Promotion Code";
                                QuickQuoteWorkSheet.INSERT;
                                //LineNo := LineNo + 1;
                            end
                            else begin
                                StockStatusQuickQuote."Current UOM" := "Current UOM";
                                StockStatusQuickQuote.MODIFY;
                                QuickQuoteWorkSheet.RESET;
                                QuickQuoteWorkSheet.SETRANGE("Item No.", "Item No.");
                                if QuickQuoteWorkSheet.FIND('+') then begin
                                    OldLineNo := QuickQuoteWorkSheet."Line No.";
                                    //LineNo := QuickQuoteWorkSheet."Line No." + 1;
                                end else begin
                                    QuickQuoteWorkSheet.RESET;
                                    if QuickQuoteWorkSheet.FIND('+') then LineNo := QuickQuoteWorkSheet."Line No.";
                                    OldLineNo := LineNo;
                                    LineNo := QuickQuoteWorkSheet."Line No." + 1;
                                end;
                                QuickQuoteWorkSheet.TRANSFERFIELDS(StockStatusQuickQuote);
                                if ItemUOM.GET("Item No.", "Current UOM") then
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := ItemUOM."Qty. per Unit of Measure"
                                else
                                    QuickQuoteWorkSheet."Qty per Unit of Measure" := 1;
                                QuickQuoteWorkSheet."Current Qty (Base)" := QuickQuoteWorkSheet."Qty per Unit of Measure" * "Current Qty.";
                                QuickQuoteWorkSheet."Promotion Code" := "Promotion Code";
                                QuickQuoteWorkSheet."Line No." := OldLineNo;
                                QuickQuoteWorkSheet.MODIFY;
                            end;
                        end;
                        if "Current UOM" <> xRec."Current UOM" then UpdateSingleLine("Location Code");
                    end;
                }
                field("Unit Cost"; "Unit Cost")
                {
                    Editable = false;
                    HideValue = ESACC_F23_HideValue;
                    Visible = ESACC_F23_Visible;
                }
                field("Average Unit Cost"; "Average Unit Cost")
                {
                    DecimalPlaces = 2 : 4;
                    Visible = false;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    Editable = false;
                    HideValue = ESACC_F2_HideValue;
                    Visible = false;
                }
                field("Lost Opportunity"; "Lost Opportunity")
                {
                    Editable = false;
                    HideValue = ESACC_F50026_HideValue;
                    Visible = ESACC_F50026_Visible;
                }
                field("Reason Code"; "Reason Code")
                {
                    Editable = ESACC_F50027_Editable;
                    HideValue = ESACC_F50027_HideValue;
                    Visible = ESACC_F50027_Visible;

                    trigger OnValidate();
                    begin

                        if "Reason Code" <> xRec."Reason Code" then UpdateLastSalesPrice(Rec);
                        if "Reason Code" <> '' then begin
                            StockStatusQuickQuote."Reason Code" := "Reason Code";
                            StockStatusQuickQuote."Reason Code Comment" := "Reason Code Comment"; //TOP010 KT ABCSI Stock Status Quick Quote 06042015
                            StockStatusQuickQuote."Lost Opportunity Description" := "Lost Opportunity Description";  //TOP230 KT ABCSI CRP 2 Fixes 06092015
                            StockStatusQuickQuote."Lost Opportunity" := "Lost Opportunity";
                            StockStatusQuickQuote.MODIFY;
                            QuickQuoteWorkSheet.RESET;
                            QuickQuoteWorkSheet.SETRANGE("Item No.", "Item No.");
                            if QuickQuoteWorkSheet.FIND('+') then
                                OldLineNo := QuickQuoteWorkSheet."Line No.";
                            QuickQuoteWorkSheet.TRANSFERFIELDS(StockStatusQuickQuote);
                            QuickQuoteWorkSheet.MODIFY;
                        end;
                    end;
                }
                field("Reason Code Comment"; "Reason Code Comment")
                {
                    Editable = ESACC_F50028_Editable;
                    HideValue = ESACC_F50028_HideValue;
                    Visible = ESACC_F50028_Visible;

                    trigger OnValidate();
                    begin

                        if xRec."Reason Code Comment" <> "Reason Code Comment" then UpdateLastSalesPrice(Rec);
                        if "Reason Code Comment" <> '' then begin
                            StockStatusQuickQuote."Reason Code Comment" := "Reason Code Comment";
                            StockStatusQuickQuote.MODIFY;
                            QuickQuoteWorkSheet.RESET;
                            QuickQuoteWorkSheet.SETRANGE("Item No.", "Item No.");
                            if QuickQuoteWorkSheet.FIND('+') then
                                OldLineNo := QuickQuoteWorkSheet."Line No.";
                            QuickQuoteWorkSheet.TRANSFERFIELDS(StockStatusQuickQuote);
                            QuickQuoteWorkSheet.MODIFY;
                        end;
                    end;
                }
                field("Lost Opportunity Description"; "Lost Opportunity Description")
                {
                    Editable = ESACC_F50029_Editable;
                    HideValue = ESACC_F50029_HideValue;
                    Visible = ESACC_F50029_Visible;
                }
                field("Last Unit Price"; "Last Unit Price")
                {
                    Editable = false;
                    HideValue = ESACC_F50007_HideValue;
                    Visible = ESACC_F50007_Visible;
                }
                field("Last Price UOM"; "Last Price UOM")
                {
                    Editable = false;
                    HideValue = ESACC_F50008_HideValue;
                    Visible = ESACC_F50008_Visible;
                }
                field("Last Price Qty."; "Last Price Qty.")
                {
                    Editable = ESACC_F50009_Editable;
                    HideValue = ESACC_F50009_HideValue;
                    Visible = ESACC_F50009_Visible;
                }
                field("Last Price Date"; "Last Price Date")
                {
                    Editable = ESACC_F50013_Editable;
                    HideValue = ESACC_F50013_HideValue;
                    Visible = ESACC_F50013_Visible;
                }
                field("Last Price User ID"; "Last Price User ID")
                {
                    Editable = false;
                    HideValue = ESACC_F50031_HideValue;
                    Visible = ESACC_F50031_Visible;
                }
                field("Last Reason Code"; "Last Reason Code")
                {
                    Editable = false;
                    HideValue = ESACC_F50010_HideValue;
                    Visible = ESACC_F50010_Visible;
                }
                field("Last Reason Code Comment"; "Last Reason Code Comment")
                {
                    Editable = false;
                    HideValue = ESACC_F50011_HideValue;
                    Visible = ESACC_F50011_Visible;
                }
                field("Last Lost Opportunity"; "Last Lost Opportunity")
                {
                    Editable = false;
                    HideValue = ESACC_F50012_HideValue;
                    Visible = ESACC_F50012_Visible;
                }
                field("Last Quoted Unit Price"; "Last Quoted Unit Price")
                {
                    Editable = false;
                    HideValue = ESACC_F50002_HideValue;
                    Visible = ESACC_F50002_Visible;
                }
                field("Pre Increase Unit Price"; "Pre Increase Unit Price")
                {
                    Editable = false;
                }
                field("Post Increase Unit Price"; "Post Increase Unit Price")
                {
                    Editable = false;
                    StyleExpr = StyleTxtNew;
                }
                field("Last Quoted Qty."; "Last Quoted Qty.")
                {
                    Editable = false;
                    HideValue = ESACC_F50004_HideValue;
                    Visible = ESACC_F50004_Visible;
                }
                field("Last Quoted UOM"; "Last Quoted UOM")
                {
                    Editable = false;
                    HideValue = ESACC_F50003_HideValue;
                    Visible = ESACC_F50003_Visible;
                }
                field("Last Invoice Price"; "Last Invoice Price")
                {
                    Editable = false;
                    HideValue = ESACC_F50014_HideValue;
                    Visible = ESACC_F50014_Visible;
                }
                field("Last Invoiced Qty."; "Last Invoiced Qty.")
                {
                    Editable = false;
                    HideValue = ESACC_F50015_HideValue;
                    Visible = ESACC_F50015_Visible;
                }
                field("Qty. on Purch. Order"; "Qty. on Purch. Order")
                {
                    Editable = false;
                    HideValue = ESACC_F84_HideValue;
                    Visible = ESACC_F84_Visible;

                    trigger OnLookup(var Text: Text): Boolean;
                    var
                        PurchLines: Record "Purchase Line";
                    begin
                        PurchLines.RESET;
                        PurchLines.SETRANGE("Document Type", PurchLines."Document Type"::Order);
                        PurchLines.SETRANGE(Type, PurchLines.Type::Item);
                        PurchLines.SETRANGE("No.", "Item No.");
                        PurchLines.SETRANGE("Location Code", "Location Code");
                        PAGE.RUN(518, PurchLines);
                    end;
                }
                field("Vendor Item No."; "Vendor Item No.")
                {
                    Editable = false;
                    HideValue = ESACC_F32_HideValue;
                    Visible = ESACC_F32_Visible;
                }
                field("Qty. on Sales Order"; "Qty. on Sales Order")
                {
                    Editable = false;
                    HideValue = ESACC_F85_HideValue;
                    Visible = ESACC_F85_Visible;
                }
                field("Cust. Qty. on SO"; "Cust. Qty. on SO")
                {
                    Editable = false;
                    HideValue = ESACC_F50016_HideValue;
                    Visible = ESACC_F50016_Visible;
                }
                field("Qty. on Hand"; "Qty. on Hand")
                {
                    Editable = false;
                    HideValue = ESACC_F50017_HideValue;
                    Visible = ESACC_F50017_Visible;
                }
                field("Total Qty. on Hand"; "Total Qty. on Hand")
                {
                    Editable = false;
                    HideValue = ESACC_F50018_HideValue;
                    Visible = ESACC_F50018_Visible;
                }
                field("CalcQtyOnPick(""Item No."",""Location Code"")"; CalcQtyOnPick("Item No.", "Location Code"))
                {
                    Caption = 'Qty. on Pick Loc.';
                    Editable = false;

                    trigger OnDrillDown();
                    var
                        WhseActivityLine: Record "Warehouse Activity Line";
                    begin
                        //TOP010 - Stock Status Quick Quote Screen - KT ABCSI 11052015
                        WhseActivityLine.RESET;
                        WhseActivityLine.SETRANGE("Activity Type", WhseActivityLine."Activity Type"::Pick);
                        WhseActivityLine.SETRANGE("Item No.", "Item No.");
                        WhseActivityLine.SETRANGE("Location Code", "Location Code");
                        WhseActivityLine.SETFILTER(
                          "Action Type",
                          '%1|%2',
                          WhseActivityLine."Action Type"::" ",
                          WhseActivityLine."Action Type"::Take);
                        WhseActivityLine.SETRANGE("Breakbulk No.", 0);
                        PAGE.RUN(0, WhseActivityLine);
                        //TOP010 - Stock Status Quick Quote Screen - KT ABCSI 11052015
                    end;
                }
                /* field("WhseCreatePick.QtyAvailtoPick(""Item No."",""Location Code"")"; WhseCreatePick.QtyAvailtoPick("Item No.", "Location Code"))
                {
                    Caption = 'Qty. Avail to Pick';
                    Editable = false;

                    trigger OnDrillDown();
                    var
                        Location: Record Location;
                        BinContent: Record "Bin Content";
                    begin
                        //TOP010 - Stock Status Quick Quote Screen - KT ABCSI 11052015
                        if Location.GET("Location Code") and
                          Location."Bin Mandatory"
                        then begin
                            BinContent.RESET;
                            BinContent.SETRANGE("Location Code", "Location Code");
                            BinContent.SETRANGE("Item No.", "Item No.");
                            BinContent.SETRANGE("Bin Type Code", 'PICKPUT');
                            BinContent.SETFILTER("Block Movement", '<>%1&<>%2', BinContent."Block Movement"::Outbound, BinContent."Block Movement"::All);
                            PAGE.RUN(PAGE::"Item Bin Contents", BinContent);
                        end;
                        //TOP010 - Stock Status Quick Quote Screen - KT ABCSI 11052015
                    end;
                } *///TODO:
                field("Promotion Code"; "Promotion Code")
                {
                    Editable = ESACC_F50020_Editable;
                    HideValue = ESACC_F50020_HideValue;
                    Visible = ESACC_F50020_Visible;
                }
                field("Curr. Unit Price Starting Date"; "Curr. Unit Price Starting Date")
                {
                    Editable = false;
                    HideValue = ESACC_F50021_HideValue;
                    Visible = ESACC_F50021_Visible;
                }
                field("Curr. Unit Price Ending Date"; "Curr. Unit Price Ending Date")
                {
                    Editable = false;
                    HideValue = ESACC_F50022_HideValue;
                    Visible = ESACC_F50022_Visible;
                }
                field("Low Unit Price"; "Low Unit Price")
                {
                    Editable = false;
                    HideValue = ESACC_F50023_HideValue;
                    Visible = ESACC_F50023_Visible;
                }
                field("Medium Unit Price"; "Medium Unit Price")
                {
                    Editable = false;
                    HideValue = ESACC_F50030_HideValue;
                    Visible = ESACC_F50030_Visible;
                }
                field("High Unit Price"; "High Unit Price")
                {
                    Editable = false;
                    HideValue = ESACC_F50024_HideValue;
                    Visible = ESACC_F50024_Visible;
                }
                field("Last Price Change Date"; "Last Price Change Date")
                {
                    Editable = false;
                    HideValue = ESACC_F50025_HideValue;
                    Visible = ESACC_F50025_Visible;
                }
                field("Sorting Order"; "Sorting Order")
                {
                    Editable = false;
                    HideValue = ESACC_F51077_HideValue;
                    Visible = false;
                }
                field("MSRP Price"; "MSRP Price")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Go Home")
            {
                Enabled = ESACC_C1000000055_Enabled;
                Image = MoveUp;
                ShortCutKey = 'F12';
                Visible = ESACC_C1000000055_Visible;

                trigger OnAction();
                begin
                    FINDFIRST; //TOP010D KT ABCSI SSQQ Unit Price 07142015
                end;
            }
            action("Clear Filter")
            {
                Scope = Page;
                ShortCutKey = 'Ctrl+m';
                Visible = false;

                trigger OnAction();
                begin
                    //MESSAGE('Clear Filter Message');
                    CurrPage.ACTIVATE(true);
                end;
            }
            action(FilterCAAllowed)
            {
                Caption = 'CA Allowed Filter';
                Image = "Filter";
                Promoted = true;

                trigger OnAction();
                var
                    Item: Record Item;
                    TempFilteredItem: Record Item temporary;
                    ItemAttributeManagement: Codeunit "Item Attribute Management";
                    TypeHelper: Codeunit "Type Helper";
                    CloseAction: Action;
                    FilterText: Text;
                    FilterPageID: Integer;
                    ParameterCount: Integer;
                    TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
                    TempItemFilteredFromAttributes: Record Item temporary;
                    RunOnTempRec: Boolean;
                begin
                    // <TPZ2859>
                    FILTERGROUP(0);
                    SETFILTER("Item Attribute Value ID", '816');
                    //</TPZ2859>
                end;
            }
            action(FilterByAttribute)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Attribute Filter';
                Image = EditFilter;
                Promoted = true;
                PromotedCategory = New;
                PromotedOnly = true;

                trigger OnAction();
                var
                    Item: Record Item;
                    TempFilteredItem: Record Item temporary;
                    ItemAttributeManagement: Codeunit "Item Attribute Management";
                    TypeHelper: Codeunit "Type Helper";
                    CloseAction: Action;
                    FilterText: Text;
                    FilterPageID: Integer;
                    ParameterCount: Integer;
                    TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
                    TempItemFilteredFromAttributes: Record Item temporary;
                    RunOnTempRec: Boolean;
                begin
                    // <TPZ2859>
                    FilterPageID := PAGE::"Filter Items by Attribute";
                    if CURRENTCLIENTTYPE = CLIENTTYPE::Phone then
                        FilterPageID := PAGE::"Filter Items by Att. Phone";

                    CloseAction := PAGE.RUNMODAL(FilterPageID, TempFilterItemAttributesBuffer);
                    if (CURRENTCLIENTTYPE <> CLIENTTYPE::Phone) and (CloseAction <> ACTION::LookupOK) then
                        exit;

                    ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer, TempItemFilteredFromAttributes);
                    FilterText := ItemAttributeManagement.GetItemNoFilterText(TempItemFilteredFromAttributes, ParameterCount);

                    if ParameterCount < TypeHelper.GetMaxNumberOfParametersInSQLQuery - 100 then begin
                        FILTERGROUP(0);
                        MARKEDONLY(false);
                        SETFILTER("Item No.", FilterText);
                    end else begin
                        RunOnTempRec := true;
                        CLEARMARKS;
                        RESET;
                    end;
                    // </TPZ2859>
                end;
            }
            action(ClearAttFilter)
            {
                Caption = 'Clear Attribute Filter';
                Image = ClearFilter;
                Promoted = true;

                trigger OnAction();
                var
                    Item: Record Item;
                    TempFilteredItem: Record Item temporary;
                    ItemAttributeManagement: Codeunit "Item Attribute Management";
                    TypeHelper: Codeunit "Type Helper";
                    CloseAction: Action;
                    FilterText: Text;
                    FilterPageID: Integer;
                    ParameterCount: Integer;
                    TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
                    TempItemFilteredFromAttributes: Record Item temporary;
                    RunOnTempRec: Boolean;
                begin
                    // <TPZ2859>
                    FILTERGROUP(0);
                    SETFILTER("Item Attribute Value ID", '');
                    SETRANGE("Item No.");
                    // </TPZ2859>
                end;
            }
            group("&Item")
            {
                CaptionML = ENU = '&Item',
                            ESM = '&LÙnea',
                            FRC = '&Ligne',
                            ENC = '&Line';
                Image = Line;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                ESM = 'C&omentarios',
                                FRC = 'Co&mmentaires',
                                ENC = 'Co&mments';
                    Enabled = ESACC_C1000000255_Enabled;
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Item),
                                  "No." = FIELD("Item No.");
                    Visible = ESACC_C1000000255_Visible;
                }
                action("Last Prices")
                {
                    Caption = 'Last Prices';
                    Enabled = ESACC_C1000000257_Enabled;
                    RunObject = Page "Last Sales Prices";
                    RunPageLink = "Sell-to Customer No." = FIELD("Sell-to Customer No."),
                                  "Item No." = FIELD("Item No."),
                                  "Document Type" = FILTER("Posted Sales Invoice" | "Stock Status");
                    Visible = ESACC_C1000000257_Visible;
                }
                action("Country/Region Last Prices")
                {
                    Caption = 'Country/Region Last Prices';
                    Enabled = ESACC_C1000000258_Enabled;
                    Visible = ESACC_C1000000258_Visible;

                    trigger OnAction();
                    var
                        LastSalesPrice: Record "Last Sales Price";
                        CustLoc: Record Customer;
                    begin
                        // <TPZ449>
                        LastSalesPrice.RESET;
                        LastSalesPrice.SETRANGE("Item No.", "Item No.");
                        CustLoc.GET("Sell-to Customer No.");
                        LastSalesPrice.SETRANGE("Country/Region Code", CustLoc."Country/Region Code");
                        PAGE.RUN(PAGE::"Last Sales Prices", LastSalesPrice);
                        // </TPZ449>
                    end;
                }
                action("Ledger E&ntries")
                {
                    CaptionML = ENU = 'Ledger E&ntries',
                                ESM = '&Movimientos',
                                FRC = 'Ù&critures comptables',
                                ENC = 'Ledger E&ntries';
                    Enabled = ESACC_C1000000058_Enabled;
                    Image = ItemLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    /*                     RunObject = Page "S.S. Item Ledger Entries";
                                        RunPageLink = "Item No." = FIELD("Item No."),
                                                      "Document Type" = FILTER("Sales Shipment" | "Sales Return Receipt" | "Sales Credit Memo" | "Purchase Receipt" | "Transfer Shipment" | "Transfer Receipt");
                                        RunPageView = SORTING("Item No."); *///TODO:

                    ShortCutKey = 'Ctrl+F7';
                    Visible = ESACC_C1000000058_Visible;
                }
                action("Cust. Group Last Sales Prices")
                {
                    Caption = 'Cust. Group Last Sales Prices';
                    Enabled = ESACC_C1000000059_Enabled;
                    Image = EntriesList;
                    Visible = ESACC_C1000000059_Visible;

                    trigger OnAction();
                    var
                        StockStatusWkshLine: Record "Stock Status Wksh. Line";
                    //StockStatusWkshMgt: Codeunit "Stock Status Wksh. Mgt.";//TODO:
                    begin
                        // <TPZ1014>
                        StockStatusWkshLine.COPY(Rec);
                        //StockStatusWkshMgt.FindRelCustLastSalesPrice(StockStatusWkshLine);//TODO:
                        // <TPZ1014>
                    end;
                }
                action(UpdateUnitPrice_ac)
                {

                    trigger OnAction();
                    begin
                        UpdateUnitPrice;
                        //MODIFY;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        UpdateLine;
        CALCFIELDS("Cust. Qty. on SO", "Qty. on Sales Order");
    end;

    trigger OnAfterGetRecord();
    begin
        CLEAR("Reason Code");
        CLEAR("Reason Code Comment");
        CLEAR("Lost Opportunity");
        CLEAR("Lost Opportunity Description");  //TOP230 KT ABCSI CRP 2 Fixes 06092015
        CLEAR("Last Reason Code");
        CLEAR("Last Reason Code Comment");
        CLEAR("Last Lost Opportunity");

        //TOP010D KT ABCSI SSQQ Unit Price 07092015
        CLEAR("Recomm. Unit Price");
        CLEAR("Last Unit Price");
        CLEAR("Last Price UOM");
        CLEAR("Last Price Qty.");
        CLEAR("Last Price Date");
        //TOP010D KT ABCSI SSQQ Unit Price 07092015

        //<TPZ2482>
        // CLEAR("Location Code");
        //CLEAR("Location Filter");
        //</TPZ2482>

        UpdateLine;
        CALCFIELDS("Cust. Qty. on SO", "Qty. on Sales Order");
        //EB <TPZ1545>
        /* CASE Blocked OF
           Blocked = TRUE:
             StyleTxt :='StandardAccent';
           {
           Blocked::"1":
             StyleTxt :='Attention';
           Blocked::"2":
             StyleTxt :='Ambiguous';
             }
           //<TPZ2531>
           {
           Blocked::NPI:
             StyleTxt :='favorable';
             }
             //</TPZ2531>
           ELSE
            StyleTxt:= 'standard';
         END;*/ //UTKARSH
                //<TPZ2531>

        SetStyleABC; //UTKARSH
        DefaultDimension.RESET;
        if DefaultDimension.GET(27, "Item No.", 'PRODLIFECYCLE') then begin
            if DefaultDimension."Dimension Value Code" = 'INTRO' then
                StyleTxtABC := 'favorable' //UTK
                                           //ELSE
                                           //StyleTxtABC:= 'Standard'; //UTK
        end;
        //</TPZ2531>
        //EB </TPZ1545>

        //SetStyleABC;

    end;

    trigger OnOpenPage();
    begin

        UserSetup.GET(USERID);
        CompanyInformation.GET;

    end;

    var
        //ESACC_ESFLADSMgt: Codeunit "ES FLADS Management";
        [InDataSet]
        ESACC_C1000000055_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000055_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000058_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000058_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000059_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000059_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000255_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000255_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000257_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000257_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000258_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000258_Enabled: Boolean;
        [InDataSet]
        ESACC_F2_Visible: Boolean;
        [InDataSet]
        ESACC_F2_Editable: Boolean;
        [InDataSet]
        ESACC_F2_HideValue: Boolean;
        [InDataSet]
        ESACC_F6_Visible: Boolean;
        [InDataSet]
        ESACC_F6_Editable: Boolean;
        [InDataSet]
        ESACC_F6_HideValue: Boolean;
        [InDataSet]
        ESACC_F7_Visible: Boolean;
        [InDataSet]
        ESACC_F7_Editable: Boolean;
        [InDataSet]
        ESACC_F7_HideValue: Boolean;
        [InDataSet]
        ESACC_F8_Visible: Boolean;
        [InDataSet]
        ESACC_F8_Editable: Boolean;
        [InDataSet]
        ESACC_F8_HideValue: Boolean;
        [InDataSet]
        ESACC_F11_Visible: Boolean;
        [InDataSet]
        ESACC_F11_Editable: Boolean;
        [InDataSet]
        ESACC_F11_HideValue: Boolean;
        [InDataSet]
        ESACC_F12_Visible: Boolean;
        [InDataSet]
        ESACC_F12_Editable: Boolean;
        [InDataSet]
        ESACC_F12_HideValue: Boolean;
        [InDataSet]
        ESACC_F19_Visible: Boolean;
        [InDataSet]
        ESACC_F19_Editable: Boolean;
        [InDataSet]
        ESACC_F19_HideValue: Boolean;
        [InDataSet]
        ESACC_F22_Visible: Boolean;
        [InDataSet]
        ESACC_F22_Editable: Boolean;
        [InDataSet]
        ESACC_F22_HideValue: Boolean;
        [InDataSet]
        ESACC_F23_Visible: Boolean;
        [InDataSet]
        ESACC_F23_Editable: Boolean;
        [InDataSet]
        ESACC_F23_HideValue: Boolean;
        [InDataSet]
        ESACC_F32_Visible: Boolean;
        [InDataSet]
        ESACC_F32_Editable: Boolean;
        [InDataSet]
        ESACC_F32_HideValue: Boolean;
        [InDataSet]
        ESACC_F54_Visible: Boolean;
        [InDataSet]
        ESACC_F54_Editable: Boolean;
        [InDataSet]
        ESACC_F54_HideValue: Boolean;
        [InDataSet]
        ESACC_F84_Visible: Boolean;
        [InDataSet]
        ESACC_F84_Editable: Boolean;
        [InDataSet]
        ESACC_F84_HideValue: Boolean;
        [InDataSet]
        ESACC_F85_Visible: Boolean;
        [InDataSet]
        ESACC_F85_HideValue: Boolean;
        [InDataSet]
        ESACC_F95_Visible: Boolean;
        [InDataSet]
        ESACC_F95_Editable: Boolean;
        [InDataSet]
        ESACC_F95_HideValue: Boolean;
        [InDataSet]
        ESACC_F5701_Visible: Boolean;
        [InDataSet]
        ESACC_F5701_Editable: Boolean;
        [InDataSet]
        ESACC_F5701_HideValue: Boolean;
        [InDataSet]
        ESACC_F5709_Visible: Boolean;
        [InDataSet]
        ESACC_F5709_Editable: Boolean;
        [InDataSet]
        ESACC_F5709_HideValue: Boolean;
        [InDataSet]
        ESACC_F5712_Visible: Boolean;
        [InDataSet]
        ESACC_F5712_Editable: Boolean;
        [InDataSet]
        ESACC_F5712_HideValue: Boolean;
        [InDataSet]
        ESACC_F50000_Visible: Boolean;
        [InDataSet]
        ESACC_F50000_Editable: Boolean;
        [InDataSet]
        ESACC_F50000_HideValue: Boolean;
        [InDataSet]
        ESACC_F50001_Visible: Boolean;
        [InDataSet]
        ESACC_F50001_Editable: Boolean;
        [InDataSet]
        ESACC_F50001_HideValue: Boolean;
        [InDataSet]
        ESACC_F50002_Visible: Boolean;
        [InDataSet]
        ESACC_F50002_Editable: Boolean;
        [InDataSet]
        ESACC_F50002_HideValue: Boolean;
        [InDataSet]
        ESACC_F50003_Visible: Boolean;
        [InDataSet]
        ESACC_F50003_Editable: Boolean;
        [InDataSet]
        ESACC_F50003_HideValue: Boolean;
        [InDataSet]
        ESACC_F50004_Visible: Boolean;
        [InDataSet]
        ESACC_F50004_Editable: Boolean;
        [InDataSet]
        ESACC_F50004_HideValue: Boolean;
        [InDataSet]
        ESACC_F50005_Visible: Boolean;
        [InDataSet]
        ESACC_F50005_Editable: Boolean;
        [InDataSet]
        ESACC_F50005_HideValue: Boolean;
        [InDataSet]
        ESACC_F50006_Visible: Boolean;
        [InDataSet]
        ESACC_F50006_Editable: Boolean;
        [InDataSet]
        ESACC_F50006_HideValue: Boolean;
        [InDataSet]
        ESACC_F50007_Visible: Boolean;
        [InDataSet]
        ESACC_F50007_Editable: Boolean;
        [InDataSet]
        ESACC_F50007_HideValue: Boolean;
        [InDataSet]
        ESACC_F50008_Visible: Boolean;
        [InDataSet]
        ESACC_F50008_Editable: Boolean;
        [InDataSet]
        ESACC_F50008_HideValue: Boolean;
        [InDataSet]
        ESACC_F50009_Visible: Boolean;
        [InDataSet]
        ESACC_F50009_Editable: Boolean;
        [InDataSet]
        ESACC_F50009_HideValue: Boolean;
        [InDataSet]
        ESACC_F50010_Visible: Boolean;
        [InDataSet]
        ESACC_F50010_Editable: Boolean;
        [InDataSet]
        ESACC_F50010_HideValue: Boolean;
        [InDataSet]
        ESACC_F50011_Visible: Boolean;
        [InDataSet]
        ESACC_F50011_Editable: Boolean;
        [InDataSet]
        ESACC_F50011_HideValue: Boolean;
        [InDataSet]
        ESACC_F50012_Visible: Boolean;
        [InDataSet]
        ESACC_F50012_Editable: Boolean;
        [InDataSet]
        ESACC_F50012_HideValue: Boolean;
        [InDataSet]
        ESACC_F50013_Visible: Boolean;
        [InDataSet]
        ESACC_F50013_Editable: Boolean;
        [InDataSet]
        ESACC_F50013_HideValue: Boolean;
        [InDataSet]
        ESACC_F50014_Visible: Boolean;
        [InDataSet]
        ESACC_F50014_Editable: Boolean;
        [InDataSet]
        ESACC_F50014_HideValue: Boolean;
        [InDataSet]
        ESACC_F50015_Visible: Boolean;
        [InDataSet]
        ESACC_F50015_Editable: Boolean;
        [InDataSet]
        ESACC_F50015_HideValue: Boolean;
        [InDataSet]
        ESACC_F50016_Visible: Boolean;
        [InDataSet]
        ESACC_F50016_HideValue: Boolean;
        [InDataSet]
        ESACC_F50017_Visible: Boolean;
        [InDataSet]
        ESACC_F50017_Editable: Boolean;
        [InDataSet]
        ESACC_F50017_HideValue: Boolean;
        [InDataSet]
        ESACC_F50018_Visible: Boolean;
        [InDataSet]
        ESACC_F50018_Editable: Boolean;
        [InDataSet]
        ESACC_F50018_HideValue: Boolean;
        [InDataSet]
        ESACC_F50020_Visible: Boolean;
        [InDataSet]
        ESACC_F50020_Editable: Boolean;
        [InDataSet]
        ESACC_F50020_HideValue: Boolean;
        [InDataSet]
        ESACC_F50021_Visible: Boolean;
        [InDataSet]
        ESACC_F50021_Editable: Boolean;
        [InDataSet]
        ESACC_F50021_HideValue: Boolean;
        [InDataSet]
        ESACC_F50022_Visible: Boolean;
        [InDataSet]
        ESACC_F50022_Editable: Boolean;
        [InDataSet]
        ESACC_F50022_HideValue: Boolean;
        [InDataSet]
        ESACC_F50023_Visible: Boolean;
        [InDataSet]
        ESACC_F50023_Editable: Boolean;
        [InDataSet]
        ESACC_F50023_HideValue: Boolean;
        [InDataSet]
        ESACC_F50024_Visible: Boolean;
        [InDataSet]
        ESACC_F50024_Editable: Boolean;
        [InDataSet]
        ESACC_F50024_HideValue: Boolean;
        [InDataSet]
        ESACC_F50025_Visible: Boolean;
        [InDataSet]
        ESACC_F50025_Editable: Boolean;
        [InDataSet]
        ESACC_F50025_HideValue: Boolean;
        [InDataSet]
        ESACC_F50026_Visible: Boolean;
        [InDataSet]
        ESACC_F50026_Editable: Boolean;
        [InDataSet]
        ESACC_F50026_HideValue: Boolean;
        [InDataSet]
        ESACC_F50027_Visible: Boolean;
        [InDataSet]
        ESACC_F50027_Editable: Boolean;
        [InDataSet]
        ESACC_F50027_HideValue: Boolean;
        [InDataSet]
        ESACC_F50028_Visible: Boolean;
        [InDataSet]
        ESACC_F50028_Editable: Boolean;
        [InDataSet]
        ESACC_F50028_HideValue: Boolean;
        [InDataSet]
        ESACC_F50029_Visible: Boolean;
        [InDataSet]
        ESACC_F50029_Editable: Boolean;
        [InDataSet]
        ESACC_F50029_HideValue: Boolean;
        [InDataSet]
        ESACC_F50030_Visible: Boolean;
        [InDataSet]
        ESACC_F50030_Editable: Boolean;
        [InDataSet]
        ESACC_F50030_HideValue: Boolean;
        [InDataSet]
        ESACC_F50031_Visible: Boolean;
        [InDataSet]
        ESACC_F50031_Editable: Boolean;
        [InDataSet]
        ESACC_F50031_HideValue: Boolean;
        [InDataSet]
        ESACC_F50040_Visible: Boolean;
        [InDataSet]
        ESACC_F50040_Editable: Boolean;
        [InDataSet]
        ESACC_F50040_HideValue: Boolean;
        [InDataSet]
        ESACC_F50100_Visible: Boolean;
        [InDataSet]
        ESACC_F50100_Editable: Boolean;
        [InDataSet]
        ESACC_F50100_HideValue: Boolean;
        [InDataSet]
        ESACC_F50202_Visible: Boolean;
        [InDataSet]
        ESACC_F50202_Editable: Boolean;
        [InDataSet]
        ESACC_F50202_HideValue: Boolean;
        [InDataSet]
        ESACC_F51077_Visible: Boolean;
        [InDataSet]
        ESACC_F51077_Editable: Boolean;
        [InDataSet]
        ESACC_F51077_HideValue: Boolean;
        StockStatusQuickQuote: Record "Stock Status Wksh. Line" temporary;
        QuickQuoteWorkSheet: Record "Quick Quote Worksheet Line" temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        // WhseCreatePick: Codeunit "Codeunit5778EventSubscriber";//TODO:
        LineNo: Integer;
        PrevLocationCode: Code[10];
        NextLocationCode: Code[10];
        LocationUpdated: Boolean;
        InFromItemNo: Code[20];
        InToItemNo: Code[20];
        InCustFilter: Code[20];
        InLocFilter: Code[10];
        Item: Record Item;
        Item2: Record Item;
        UserSetup: Record "User Setup";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLineNo: Integer;
        ItemUnitCost: Decimal;
        ItemUnitPrice: Decimal;
        EffPriceIncrDate: Date;
        QtyPerUOM: Decimal;
        UOMMgt: Codeunit "Unit of Measure Management";
        ItemAvail: Decimal;
        ItemQOH: Decimal;
        ItemQPO: Decimal;
        ItemLead: DateFormula;
        CompanyInformation: Record "Company Information";
        Item3: Record Item;
        MItemAvail: Decimal;
        LastSalesPrice: Record "Last Sales Price";
        NewLastSalesPrice: Record "Last Sales Price";
        SalesPrice: Record "Sales Price";
        NewSalesPrice: Record "Sales Price";
        BaseUOM: Code[10];
        Company: Record "Company Information";
        OrderTotal: Decimal;
        SLoc: Record Location;
        MultiOrder: Boolean;
        FirstNo: Code[10];
        LastNo: Code[10];
        ONo: Code[10];
        LastPriceInfo: Text[60];
        LastPriceUserID: Code[10];
        Customer: Record Customer;
        WLoc: Record Location;
        ItemUOM: Record "Item Unit of Measure";
        OldLineNo: Integer;
        TempSalesHeader: Record "Sales Header" temporary;
        TempSalesLine: Record "Sales Line" temporary;
        LastSalesLineNo: Integer;
        CurrDivisionCodeFilter: Code[20];
        LastLostOpportunity: Record "Lost Opportunity";
        DocType: Option Quote,"Order","Stock Status";
        Text00001: Label 'There are No Lines with Current Qty Populated. \ Please poulate Lines with Curr. Quantity and Unit Price to Proceed further';
        Text00002: Label 'There are Lines with Current Qty Populated. \ Are you sure you want to change the Division Code?';
        Text00003: Label 'Processing halted to respect the user selection';
        //ItemMgt: Codeunit "Item Management";//TODO:
        xItemNo: Text;
        xVendorItemNo: Text;
        //WSHSHELL : Automation 'Microsoft Shell Controls And Automation'.Shell ; //VAH
        //MSVBD : DotNet "'Microsoft.VisualBasic, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.Microsoft.VisualBasic.Devices.Keyboard" RUNONCLIENT;
        Newunitprice: Decimal;
        StyleTxtNew: Text;
        ItemDivisionMatrix: Record "Item Division Matrix";//TODO:
        DefaultDimension: Record "Default Dimension";
        //StockStatusQuickQuoteMgt: Codeunit "Stock Status Wksh. Mgt. Al";//TODO:
        StyleTxtABC: Text;




    procedure UserPrompt();
    begin
        //TOP010B KT ABCSI SSQQ Division Code 07092015
        QuickQuoteWorkSheet.RESET;
        QuickQuoteWorkSheet.SETCURRENTKEY("Location Code", Description, "Item No.", "Sell-To Customer No.");
        QuickQuoteWorkSheet.SETFILTER("Current Qty.", '<>%1', 0);
        QuickQuoteWorkSheet.SETFILTER("Lost Opportunity", '%1', false);
        if QuickQuoteWorkSheet.FINDFIRST then
            if not CONFIRM(Text00002) then
                ERROR(Text00003) else begin
                CheckLostOpportunity;
                StockStatusQuickQuote.RESET;
                StockStatusQuickQuote.DELETEALL;
                QuickQuoteWorkSheet.RESET;
                QuickQuoteWorkSheet.DELETEALL;
                CLEAR(LineNo);
            end;
        //TOP010B KT ABCSI SSQQ Division Code 07092015
    end;

    procedure UserUpdate();
    begin
        CurrPage.UPDATE(false);
    end;

    procedure Refresh(NewCust: Boolean);
    var
        CustRec: Record Customer;
        ItemDivMatrix: Record "Item Division Matrix";
        ItemABC1: Record Item;
    begin
        if NewCust then begin
            CheckLostOpportunity;
            StockStatusQuickQuote.RESET;
            StockStatusQuickQuote.DELETEALL;
            QuickQuoteWorkSheet.RESET;
            QuickQuoteWorkSheet.DELETEALL;
            CLEAR(LineNo);
        end;

        RESET;

        //TOP130 KT ABCSI Item List Sort and Filter by Status 04102015 Start
        // <TPZ591>
        ASCENDING := true;
        SETCURRENTKEY("Sorting Order");
        // </TPZ591>

        if CustRec.GET(InCustFilter) then begin
            if (not CustRec."Non Divisional") then begin
                FILTERGROUP(2);
                if ItemDivMatrix.GET(CurrDivisionCodeFilter) then
                    SETFILTER("Shortcut Dimension 5 Code", ItemDivMatrix."Divisional Filter");
                FILTERGROUP(0);
            end;
        end;
        //TOP130 KT ABCSI Item List Sort and Filter by Status 04102015 End
        //<TPZ1801>
        //SETFILTER(Blocked,'<>%1',Blocked::All); //EB
        SETFILTER(Blocked, '<>%1', true); //EB //UTK TPZ2785
                                          //<TPZ1801>
        SETFILTER("ABC Code", '<>%1', 'OB'); //<TPZ2839>

        /*
        IF InCustFilter <> '' THEN
           QuickQuoteWorkSheet.SETRANGE("Sell-To Customer No.", InCustFilter);
        IF NOT QuickQuoteWorkSheet.FIND('+') THEN
           LineNo := 1
        ELSE
           LineNo := QuickQuoteWorkSheet."Line No." + 1;
        */
        if FIND('-') then;
        CurrPage.UPDATE(false);
        CurrPage.ACTIVATE;

    end;

    procedure FindItemNo(varItemNo: Code[20]);
    var
        icnt: Integer;
        wrk: Record "Stock Status Wksh. Line";
        sItemNo: Code[20];
        sDivisionalFilter: Text[20];
    begin
        //TOP10C KT ABCSI - SSQQ Item Search 07082015
        //>>RS1.00
        varItemNo := UPPERCASE(varItemNo);
        if ItemDivisionMatrix.GET("Shortcut Dimension 5 Code") then
            sDivisionalFilter := ItemDivisionMatrix."Divisional Filter";

        wrk.RESET;
        wrk.SETCURRENTKEY("Sorting Order");
        //wrk.SETCURRENTKEY("Item No.");
        if sDivisionalFilter <> '' then
            wrk.SETFILTER("Shortcut Dimension 5 Code", ItemDivisionMatrix."Divisional Filter")
        else
            wrk.SETRANGE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");

        //wrk.SETFILTER(Blocked, '<>All');  //gg item blocking  TPZ2785
        wrk.SETRANGE(Blocked, false);//TPZ2785
        //wrk.SETFILTER("Item No.",xItemNo + '*');
        wrk.SETFILTER("ABC Code", '<>OB'); //<TPZ2839>
        icnt := 0;
        if wrk.FINDFIRST then begin
            repeat
                icnt := icnt + 1;
                if varItemNo = COPYSTR(wrk."Item No.", 1, STRLEN(varItemNo)) then begin
                    sItemNo := wrk."Item No.";
                    wrk.FINDLAST;
                end;
            until wrk.NEXT = 0;
        end;
        //MESSAGE(sItemNo + ' ' + FORMAT(icnt));
        SETFILTER("Item No.", sItemNo);
        FINDFIRST;

        CurrPage.UPDATE(false);
        CurrPage.ACTIVATE(true);
        if CURRENTCLIENTTYPE = CLIENTTYPE::Windows then begin
            /*if ISCLEAR(WSHSHELL) then
              CREATE(WSHSHELL, true, true);
            WSHSHELL.SendKeys('{F5}');*///VAH
        end;

        SETFILTER("Shortcut Dimension 5 Code", sDivisionalFilter);
        //RS1.00

        /*IF ISCLEAR(WSHSHELL) THEN
          CREATE(WSHSHELL, TRUE, TRUE);
        
        WSHSHELL.SendKeys('^Z');*/


        //MSVBD := MSVBD.Keyboard;
        //MSVBD.SendKeys('^Z');
        //MSVBD.SendKeys('^+A');
        //TOP10C KT ABCSI - SSQQ Item Search 07082015

    end;

    procedure FindVendItemNo(varVendItemNo: Text[30]);
    var
        wrk: Record "Stock Status Wksh. Line";
        icnt: Integer;
        sItemNo: Code[20];
        sDivisionalFilter: Text[20];
    begin
        //TOP10E KT ABCSI - Additional Stock Status 07282015
        varVendItemNo := DELCHR(DELCHR(UPPERCASE(varVendItemNo), '=', '&'), '=', ' ');

        wrk.SETCURRENTKEY("Sorting Order");
        if ItemDivisionMatrix.GET("Shortcut Dimension 5 Code") then
            sDivisionalFilter := ItemDivisionMatrix."Divisional Filter";

        //wrk.SETCURRENTKEY("Vendor Item No.");
        if sDivisionalFilter <> '' then
            wrk.SETFILTER("Shortcut Dimension 5 Code", ItemDivisionMatrix."Divisional Filter")
        else
            wrk.SETRANGE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");

        //wrk.SETFILTER(Blocked, '<>All');  //gg item blocking TPZ2785
        wrk.SETRANGE(Blocked, false);//TPZ2785
        //wrk.SETFILTER("Item No.",xVendorItemNo + '*');
        wrk.SETFILTER("ABC Code", '<>OB'); //<TPZ2839>
        icnt := 0;
        if wrk.FINDFIRST then begin
            repeat
                icnt := icnt + 1;
                if varVendItemNo = DELCHR(DELCHR(UPPERCASE(COPYSTR(wrk."Vendor Item No.", 1, STRLEN(varVendItemNo))), '=', '&'), '=', ' ') then begin
                    sItemNo := wrk."Vendor Item No.";
                    wrk.FINDLAST;
                end;
            until wrk.NEXT = 0;
        end;
        //MESSAGE(sItemNo + ' ' + FORMAT(icnt));
        sItemNo := CONVERTSTR(sItemNo, '&', '*');
        SETFILTER("Vendor Item No.", sItemNo);
        FINDFIRST;

        CurrPage.UPDATE(false);
        CurrPage.ACTIVATE(true);
        if CURRENTCLIENTTYPE = CLIENTTYPE::Windows then begin
            /*if ISCLEAR(WSHSHELL) then
              CREATE(WSHSHELL, true, true);
            WSHSHELL.SendKeys('{F5}');*///VAH
        end;
        SETFILTER("Shortcut Dimension 5 Code", sDivisionalFilter);
        //RS1.00

        //TOP10E KT ABCSI - Additional Stock Status 07282015
    end;

    procedure SetUserFilters(InCustomer: Code[20]; InLocation: Code[10]; InDivisionCodeFilter: Code[20]);
    begin
        InCustFilter := InCustomer;
        InLocFilter := InLocation;
        CurrDivisionCodeFilter := InDivisionCodeFilter;
        UpdateLine;
    end;

    procedure UpdateLastSalesPrice(var InRec: Record "Stock Status Wksh. Line");
    var
        CustLoc: Record Customer;
    begin
        if Item.GET(InRec."Item No.") then begin
            BaseUOM := Item."Base Unit of Measure";
        end;

        if "Unit Price" = 0 then
            exit;
        NewLastSalesPrice.RESET;
        NewLastSalesPrice.SETRANGE("Document Type", NewLastSalesPrice."Document Type"::"Stock Status");
        NewLastSalesPrice.SETRANGE("Document No.", '');
        NewLastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
        NewLastSalesPrice.SETRANGE("Item No.", "Item No.");
        NewLastSalesPrice.SETRANGE("Unit of Measure Code", "Current UOM");
        if NewLastSalesPrice.FINDFIRST then begin
            NewLastSalesPrice."Document Date" := "Order Date";
            NewLastSalesPrice."Last Unit Price" := "Unit Price";
            NewLastSalesPrice."Last Price UOM" := "Current UOM";
            NewLastSalesPrice."Last Price Qty." := "Current Qty.";
            NewLastSalesPrice."Last Price Date" := TODAY;
            NewLastSalesPrice."Last Price User ID" := USERID;
            NewLastSalesPrice.MODIFY;
        end else begin
            if "Special Price" then //TPZ2970
                exit; //TPZ2970
            NewLastSalesPrice.INIT;
            NewLastSalesPrice."Document Type" := NewLastSalesPrice."Document Type"::"Stock Status";
            NewLastSalesPrice."Document No." := '';
            // <TPZ1014>
            NewLastSalesPrice.VALIDATE("Sell-to Customer No.", InCustFilter);
            // </TPZ1014>
            NewLastSalesPrice."Item No." := "Item No.";
            NewLastSalesPrice."Unit of Measure Code" := "Current UOM";
            NewLastSalesPrice."Document Date" := "Order Date";
            NewLastSalesPrice."Last Unit Price" := "Unit Price";
            NewLastSalesPrice."Last Price UOM" := "Current UOM";
            NewLastSalesPrice."Last Price Qty." := "Current Qty.";
            NewLastSalesPrice."Last Price Date" := TODAY;
            NewLastSalesPrice."Last Price User ID" := USERID;
            // <TPZ449>
            if CustLoc.GET(InCustFilter) then begin
                NewLastSalesPrice."Shortcut Dimension 5 Code" := CurrDivisionCodeFilter;
                NewLastSalesPrice."Country/Region Code" := CustLoc."Country/Region Code";
            end;
            // </TPZ449>
            NewLastSalesPrice.INSERT;
        end;
    end;

    procedure CalcQtyOnPick(varItemNo: Code[20]; varLocCode: Code[10]): Decimal;
    var
        ItemRec: Record Item;
    begin
        //TOP010 - Stock Status Quick Quote Screen - KT ABCSI 11052015
        ItemRec.GET(varItemNo);
        ItemRec.SETRANGE("Location Filter", varLocCode);
        ItemRec.CALCFIELDS("Qty. on Pick");
        exit(ItemRec."Qty. on Pick");
        //TOP010 - Stock Status Quick Quote Screen - KT ABCSI 11052015
    end;

    procedure NewOrderQuote(CreateType: Option "Order",Quote,"Credit Memo","Return Order"; "Doc No.": Code[10]);
    var
        OLocation: Code[10];
        NLocation: Code[10];
        OK: Boolean;
        ONo: Code[10];
        SOrders: Record "Sales Header";
        "LostQuoteNo.": Code[10];
        OnlyLost: Boolean;
        ShipToAddrDivision: Record "Ship-to Address Division";
        Item: Record Item;
    begin
        if (StockStatusQuickQuote.COUNT = 0) and ((CreateType = CreateType::Order) or (CreateType = CreateType::Quote)) then begin
            MESSAGE('There is no item to process.');
            exit;
        end;

        //TOP010 KT ABCSI Stock Status Quick Quote 06042015
        QuickQuoteWorkSheet.RESET;
        QuickQuoteWorkSheet.SETCURRENTKEY("Location Code", Description, "Item No.", "Sell-To Customer No.");
        QuickQuoteWorkSheet.SETFILTER("Current Qty.", '<>%1', 0);
        QuickQuoteWorkSheet.SETFILTER("Lost Opportunity", '%1', false);
        if not QuickQuoteWorkSheet.FINDFIRST then
            ERROR(Text00001);
        //TOP010 KT ABCSI Stock Status Quick Quote 06042015

        CheckLostOpportunity;
        StockStatusQuickQuote.SETFILTER("Lost Opportunity", '%1', false);
        if (StockStatusQuickQuote.COUNT <> 0) then begin
            CLEAR(OnlyLost);
            CLEAR(OLocation);
            CLEAR(NLocation);
            CLEAR(SalesHeader);
            CLEAR(LocationUpdated);
            CLEAR(PrevLocationCode);
            CLEAR(NextLocationCode);
            CLEAR(MultiOrder);
            CLEAR(FirstNo);
            CLEAR(LastNo);
            OrderTotal := CalcTotal(MultiOrder);
            SalesHeader.INIT;
            if CreateType = CreateType::Order then
                SalesHeader."Document Type" := SalesHeader."Document Type"::Order
            else begin
                if CreateType = CreateType::Quote then
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Quote
                else
                    exit;
            end;

            if "Doc No." = '' then begin
                SalesHeader.INSERT(true);
                SalesHeader.SetHideValidationDialog(true);
                SalesHeader.VALIDATE("Sell-to Customer No.", InCustFilter);
                SalesHeader.VALIDATE("Payment Terms Code");
                SalesHeader.VALIDATE("Shortcut Dimension 5 Code", CurrDivisionCodeFilter);  //TOP130 KT ABCSI Item List Sort and Filter by Status 04172015
                SalesHeader."Location Code" := '';
                SalesHeader.VALIDATE("Order Date", TODAY);
                SalesHeader.MODIFY(true);
                //TOP040 KT ABCSI Sales Order Split by Locations 03052015 Commented per SMT
                /*
                FirstNo := SalesHeader."No.";
                IF MultiOrder THEN BEGIN
                  SalesHeader."Master Order No." := FirstNo;
                  SalesHeader."Original Free Freight Base" := OrderTotal;
                END;
                LastNo := SalesHeader."No."
                */
                //TOP040 KT ABCSI Sales Order Split by Locations 03052015 Commented per SMT
            end;

            SalesLine.RESET;
            SalesLine.SETCURRENTKEY("Document Type", "Document No.");
            SalesLine.SETRANGE(SalesLine."Document Type", SalesHeader."Document Type");
            //TOP170 KT ABCSI Sales Order Updates 04022015
            if "Doc No." <> '' then
                SalesLine.SETRANGE(SalesLine."Document No.", "Doc No.")
            else
                SalesLine.SETRANGE(SalesLine."Document No.", SalesHeader."No.");
            //TOP170 KT ABCSI Sales Order Updates 04022015
            if SalesLine.FIND('+') then
                SalesLineNo := SalesLine."Line No." + 10000
            else
                SalesLineNo := 10000;
            QuickQuoteWorkSheet.RESET;
            //QuickQuoteWorkSheet.SETCURRENTKEY("Location Code",Description,"Item No.","Sell-To Customer No.");
            QuickQuoteWorkSheet.SETCURRENTKEY("Line No.", "Item No.", "Sell-To Customer No.");
            QuickQuoteWorkSheet.SETFILTER("Current Qty.", '<>%1', 0);
            QuickQuoteWorkSheet.SETFILTER("Lost Opportunity", '%1', false);

            if QuickQuoteWorkSheet.FIND('-') then
                repeat
                    if "Doc No." = '' then
                        if SalesHeader."Location Code" = '' then begin
                            //<TPZ1697>
                            if ShipToAddrDivision.GET(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code", SalesHeader."Shortcut Dimension 5 Code") then begin
                                if ShipToAddrDivision."Location Code" <> '' then
                                    SalesHeader.VALIDATE("Location Code", ShipToAddrDivision."Location Code");
                            end else begin
                                SalesHeader.VALIDATE(SalesHeader."Location Code", QuickQuoteWorkSheet."Location Code");
                            end;
                            //<TPZ1697>
                            // SalesHeader.VALIDATE(SalesHeader."Location Code",QuickQuoteWorkSheet."Location Code");
                            SalesHeader.MODIFY(true);
                        end;
                    //EB
                    //TOP040 KT ABCSI Sales Order Split by Locations 03052015 Commented per SMT
                    /*
                    IF OLocation = '' THEN OLocation := QuickQuoteWorkSheet."Location Code"
                    ELSE OLocation := NLocation;
                    NLocation := QuickQuoteWorkSheet."Location Code";
                    IF OLocation <> NLocation THEN BEGIN
                      SLoc.GET(NLocation);
                      CLEAR(SalesHeader);
                      SalesHeader.INIT;
                      IF CreateType = CreateType::Order THEN
                        SalesHeader."Document Type" := SalesHeader."Document Type"::Order
                      ELSE IF CreateType = CreateType::Quote THEN
                        SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
                      IF "Doc No." = '' THEN BEGIN
                        MultiOrder := TRUE;
                        SalesHeader.INSERT(TRUE);
                        SalesHeader.SetHideValidationDialog(TRUE);
                        SalesHeader.VALIDATE("Sell-to Customer No.",InCustFilter);
                        LastNo := SalesHeader."No.";
                        SalesHeader."Master Order No." := FirstNo;
                        SalesHeader."Original Free Freight Base" := OrderTotal;
                        SalesHeader.VALIDATE("Payment Terms Code");
                        SalesHeader.VALIDATE("Location Code",NLocation);
                        SalesHeader.VALIDATE("Order Date",TODAY);
                        PrevLocationCode := NLocation;
                        SalesHeader.MODIFY(TRUE);
                      END;
                    END;
                    */
                    //TOP040 KT ABCSI Sales Order Split by Locations 03052015 Commented per SMT
                    SalesLine.INIT;
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    if "Doc No." = '' then
                        SalesLine."Document No." := SalesHeader."No."
                    else
                        SalesLine."Document No." := "Doc No.";
                    SalesLine."Line No." := SalesLineNo;
                    SalesLineNo := SalesLineNo + 10000;
                    SalesLine.VALIDATE("Sell-to Customer No.", InCustFilter);
                    SalesLine.Type := SalesLine.Type::Item;
                    SalesLine.VALIDATE("No.", QuickQuoteWorkSheet."Item No.");
                    if QuickQuoteWorkSheet."Location Code" <> '' then
                        SalesLine.VALIDATE("Location Code", QuickQuoteWorkSheet."Location Code");
                    SalesLine.Quantity := QuickQuoteWorkSheet."Current Qty.";
                    SalesLine.VALIDATE("Unit of Measure Code", QuickQuoteWorkSheet."Current UOM");
                    SalesLine.VALIDATE("Unit Price", QuickQuoteWorkSheet."Unit Price");
                    SalesLine."Base UOM Price" := QuickQuoteWorkSheet."Unit Price";
                    SalesLine."Last Unit Price" := QuickQuoteWorkSheet."Last Unit Price";
                    SalesLine."Last Price UOM" := QuickQuoteWorkSheet."Last Price UOM";
                    SalesLine."Last Price Qty." := QuickQuoteWorkSheet."Last Price Qty.";
                    SalesLine."Last Price Date" := QuickQuoteWorkSheet."Last Price Date";
                    SalesLine."Modified UserID" := USERID;
                    SalesLine."Special Price" := Rec."Special Price"; //TPZ2970
                    SalesLine.INSERT(true);
                until QuickQuoteWorkSheet.NEXT = 0;
        end else
            OnlyLost := true;

        StockStatusQuickQuote.RESET;
        StockStatusQuickQuote.DELETEALL;

        QuickQuoteWorkSheet.RESET;
        QuickQuoteWorkSheet.DELETEALL;

        COMMIT;
        if not OnlyLost then begin
            if "Doc No." = '' then
                //IF NOT MultiOrder THEN BEGIN //TOP040 KT ABCSI Sales Order Split by Locations 03052015 Commented per SMT
                if CreateType = CreateType::Order then
                    PAGE.RUNMODAL(PAGE::"Sales Order", SalesHeader)
                else
                    PAGE.RUNMODAL(PAGE::"Sales Quote", SalesHeader);
            //TOP040 KT ABCSI Sales Order Split by Locations 03052015 Commented per SMT
            /*
            END ELSE BEGIN
              SOrders.RESET;
              SOrders.SETFILTER("No.",'%1..%2',FirstNo,LastNo);
              SOrders.FIND('-');
              IF CreateType = CreateType::Order THEN
                PAGE.RUNMODAL(PAGE::"Sales Order List",SOrders)
              ELSE
                PAGE.RUNMODAL(PAGE::"Sales Quotes",SOrders);
            END;
            */
            //TOP040 KT ABCSI Sales Order Split by Locations 03052015 Commented per SMT
        end;

    end;

    procedure ShowWorksheet();
    var
        // QuickQuoteWkshPg: Page "Quick Quote Worksheet";
        LocalOrderTotal: Decimal;
    begin
        QuickQuoteWorkSheet.SETCURRENTKEY("Line No.", "Item No.", "Sell-To Customer No.");
        QuickQuoteWorkSheet.SETFILTER("Line No.", '<>%1', 0);
        PAGE.RUNMODAL(50001, QuickQuoteWorkSheet);
        QuickQuoteWorkSheet.RESET;
        if QuickQuoteWorkSheet.FIND('-') then
            repeat
                if StockStatusQuickQuote.GET(QuickQuoteWorkSheet."Item No.") then begin
                    StockStatusQuickQuote."Current Qty." := QuickQuoteWorkSheet."Current Qty.";
                    StockStatusQuickQuote."Current UOM" := QuickQuoteWorkSheet."Current UOM";
                    StockStatusQuickQuote."Unit Price" := QuickQuoteWorkSheet."Unit Price";
                    StockStatusQuickQuote."Location Code" := QuickQuoteWorkSheet."Location Code";
                    StockStatusQuickQuote.MODIFY;
                end;
            until QuickQuoteWorkSheet.NEXT = 0;
    end;

    procedure UpdateLine();
    var
        OK: Boolean;
    begin

        if (StockStatusQuickQuote.GET("Item No.")) then begin
            "Current Qty." := StockStatusQuickQuote."Current Qty.";
            "Current UOM" := StockStatusQuickQuote."Current UOM";
            "Unit Price" := StockStatusQuickQuote."Unit Price";
            "Reason Code" := StockStatusQuickQuote."Reason Code";
            "Reason Code Comment" := StockStatusQuickQuote."Reason Code Comment";
            "Lost Opportunity Description" := StockStatusQuickQuote."Lost Opportunity Description";  //TOP230 KT ABCSI CRP 2 Fixes 06092015
            "Lost Opportunity" := StockStatusQuickQuote."Lost Opportunity";
            "Order Date" := TODAY;
            //TOP230 KT ABCSI CRP 2 Fixes 05282015
            "Recomm. Unit Price" := StockStatusQuickQuote."Recomm. Unit Price";
            "Recomm. Multiplier" := StockStatusQuickQuote."Recomm. Multiplier";
            //TOP230 KT ABCSI CRP 2 Fixes 05282015
            if (StockStatusQuickQuote."Location Code" <> InLocFilter) and ("Location Code" = xRec."Location Code") and (Item.Type <> Item.Type::Service) then begin //<TPZ2482>
                "Location Code" := StockStatusQuickQuote."Location Code";
                "Location Filter" := StockStatusQuickQuote."Location Code"
            end;
            //"Shortcut Dimension 5 Code" := CurrDivisionCodeFilter;
            "Sell-to Customer No." := InCustFilter;
            CALCFIELDS("Cust. Qty. on SO", "Qty. on Sales Order");
            if Item.GET("Item No.") then begin
                Description := Item.Description;
                "Unit Cost" := Item."Unit Cost";
                //"ABC Code" := Item."ABC Code";//Utkarsh
                QtyPerUOM := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Current UOM");
                Item.SETRANGE("Location Filter");
                Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Purch. Order");
                "Total Qty. on Hand" := Item.Inventory / QtyPerUOM;
                Item.SETRANGE("Location Filter", StockStatusQuickQuote."Location Code");
                Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Purch. Order");

                //<TPZ1678>
                "Quantity Available on Location" := (Item.Inventory - Item."Qty. on Sales Order") / QtyPerUOM;
                //"Quantity Available on Location" := ItemMgt.CalcQtyAvailable(Item) / QtyPerUOM;
                //</TPZ1678>

                "Qty. on Hand" := Item.Inventory / QtyPerUOM;
                "Qty. on Purch. Order" := Item."Qty. on Purch. Order" / QtyPerUOM;
                "Qty. on Sales Order" := Item."Qty. on Sales Order" / QtyPerUOM;
                ItemLead := Item."Lead Time Calculation";
                "MSRP Price" := Item."MSRP Price";//TPZ3090
                if (CompanyInformation."Location Code" <> '') and (Item3.GET("Item No.")) then begin
                    Item3.SETFILTER("Location Filter", CompanyInformation."Location Code");
                    Item3.CALCFIELDS(Inventory, "Qty. on Sales Order");
                    //<TPZ1678>
                    "Main Loc. Qty. Avail" := (Item3.Inventory - Item3."Qty. on Sales Order") / QtyPerUOM;
                    //"Main Loc. Qty. Avail" := ItemMgt.CalcQtyAvailable(Item3)/QtyPerUOM;
                    //</TPZ1675>
                end else
                    CLEAR("Main Loc. Qty. Avail");
                //TOP230 KT ABCSI CRP 2 Fixes 05282015
                "Low Unit Price" := Item."Low Unit Price";
                "High Unit Price" := Item."High Unit Price";
                "Medium Unit Price" := Item."Medium Unit Price";
                //TOP230 KT ABCSI CRP 2 Fixes 05282015
            end;

            SalesPrice.RESET;
            SalesPrice.SETRANGE("Item No.", "Item No.");
            SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::Customer);
            SalesPrice.SETRANGE("Sales Code", InCustFilter);
            if SalesPrice.FINDLAST then begin
                "Last Price Change Date" := SalesPrice."Starting Date";
                //"Low Unit Price" := SalesPrice."Low Unit Price";
                //"High Unit Price" := SalesPrice."High Unit Price";
                //"Medium Unit Price" := SalesPrice."Medium Unit Price";
                "Curr. Unit Price Starting Date" := SalesPrice."Starting Date";
                "Curr. Unit Price Ending Date" := SalesPrice."Ending Date";
            end;

            //Find Last Lost Opportunity
            LastLostOpportunity.RESET;
            //SQLPerform
            LastLostOpportunity.SETCURRENTKEY("Sell-to Customer No.", Type, "No.");
            LastLostOpportunity.SETRANGE(Type, LastLostOpportunity.Type::Item);

            LastLostOpportunity.SETRANGE("Document Type", LastLostOpportunity."Document Type"::"Stock Status");
            LastLostOpportunity.SETRANGE("No.", "Item No.");
            LastLostOpportunity.SETRANGE("Sell-to Customer No.", InCustFilter);
            if LastLostOpportunity.FINDLAST then begin
                "Last Lost Opportunity" := true;
                "Last Reason Code" := LastLostOpportunity."Reason Code";
                "Last Reason Code Comment" := LastLostOpportunity."Reason Code Comment";
            end;

            //Find Last Quoted Unit Price and related fields
            LastSalesPrice.RESET;
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
            LastSalesPrice.ASCENDING;
            //SQLPerform
            //LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.","Item No.","Document Date");
            LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Unit of Measure Code", "Document Type");
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
            LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::Quote);
            LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
            LastSalesPrice.SETRANGE("Item No.", "Item No.");
            LastSalesPrice.SETRANGE("Unit of Measure Code", "Base Unit of Measure");
            if LastSalesPrice.FINDLAST then begin
                "Last Quoted Unit Price" := LastSalesPrice."Last Unit Price";
                "Last Quoted UOM" := LastSalesPrice."Last Price UOM";
                "Last Quoted Qty." := LastSalesPrice."Last Price Qty.";
            end else begin
                "Last Quoted Unit Price" := 0;
                "Last Quoted UOM" := '';
                "Last Quoted Qty." := 0;
            end;

            //Find Last Invoiced Unit Price and related fields
            LastSalesPrice.RESET;
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
            LastSalesPrice.ASCENDING;
            //SQLPerform
            //LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.","Item No.","Document Date");
            LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Unit of Measure Code", "Document Type");
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
            LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::"Posted Sales Invoice");
            LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
            LastSalesPrice.SETRANGE("Item No.", "Item No.");
            LastSalesPrice.SETRANGE("Unit of Measure Code", "Base Unit of Measure");
            if LastSalesPrice.FINDLAST then begin
                "Last Invoice Price" := LastSalesPrice."Last Unit Price";
                "Last Invoiced Qty." := LastSalesPrice."Last Price Qty.";
            end else begin
                "Last Invoice Price" := 0;
                "Last Invoiced Qty." := 0;
            end;

            //Find Last Unit Price and related fields
            LastSalesPrice.RESET;
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
            LastSalesPrice.ASCENDING;
            LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
            LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
            LastSalesPrice.SETRANGE("Item No.", "Item No.");
            if LastSalesPrice.FINDLAST then begin
                "Last Unit Price" := LastSalesPrice."Last Unit Price";
                "Last Price UOM" := LastSalesPrice."Last Price UOM";
                "Last Price Qty." := LastSalesPrice."Last Price Qty.";
                "Last Price Date" := LastSalesPrice."Last Price Date";
                "Last Price User ID" := LastSalesPrice."Last Price User ID";  //TOP010E KT ABCSI 07282015
            end else begin
                "Last Unit Price" := 0;
                "Last Price UOM" := '';
                "Last Price Qty." := 0;
                "Last Price Date" := 0D;
                "Last Price User ID" := ''; //TOP010E KT ABCSI 07282015
            end;
        end
        else begin
            if Item.GET("Item No.") then begin
                Description := Item.Description;
                "Unit Cost" := Item."Unit Cost";
                ItemUnitPrice := Item."Unit Price";
                "Unit Price" := 0;
                "Order Date" := TODAY;
                "Current UOM" := Item."Sales Unit of Measure";
                //"ABC Code" := Item."ABC Code"; //Utkarsh
                QtyPerUOM := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Current UOM");
                Item.SETRANGE("Location Filter");
                Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Purch. Order");
                "Total Qty. on Hand" := Item.Inventory / QtyPerUOM;
                Item.SETRANGE("Location Filter", InLocFilter);
                Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Purch. Order");

                //<TPZ1675>
                "Quantity Available on Location" := (Item.Inventory - Item."Qty. on Sales Order") / QtyPerUOM;
                // "Quantity Available on Location" := ItemMgt.CalcQtyAvailable(Item) / QtyPerUOM;
                //</TPZ1675>

                "Qty. on Hand" := Item.Inventory / QtyPerUOM;
                "Qty. on Purch. Order" := Item."Qty. on Purch. Order" / QtyPerUOM;
                "Qty. on Sales Order" := Item."Qty. on Sales Order" / QtyPerUOM;
                ItemLead := Item."Lead Time Calculation";
                "MSRP Price" := Item."MSRP Price";//TPZ3090
                if (CompanyInformation."Location Code" <> '') and (Item3.GET("Item No.")) then begin
                    Item3.SETFILTER("Location Filter", CompanyInformation."Location Code");
                    Item3.CALCFIELDS(Inventory, "Qty. on Sales Order");
                    //<TPZ1675>
                    "Main Loc. Qty. Avail" := (Item3.Inventory - Item3."Qty. on Sales Order") / QtyPerUOM;
                    //"Main Loc. Qty. Avail" := ItemMgt.CalcQtyAvailable(Item3) / QtyPerUOM;
                    //</TPZ1675>
                end else
                    CLEAR("Main Loc. Qty. Avail");
                "Current Qty." := 0;
                BaseUOM := Item."Base Unit of Measure";
                if (Item.Type <> Item.Type::Service) then //<TPZ2482>
                    "Location Code" := InLocFilter;
                //"Shortcut Dimension 5 Code" := CurrDivisionCodeFilter;
                CALCFIELDS("Cust. Qty. on SO", "Qty. on Sales Order");
                "Sell-to Customer No." := InCustFilter;
                "Vendor Item No." := Item."Vendor Item No.";

                //TOP230 KT ABCSI CRP 2 Fixes 05282015
                "Low Unit Price" := Item."Low Unit Price";
                "High Unit Price" := Item."High Unit Price";
                "Medium Unit Price" := Item."Medium Unit Price";
                //TOP230 KT ABCSI CRP 2 Fixes 05282015



                SalesPrice.RESET;
                SalesPrice.SETRANGE("Item No.", "Item No.");
                SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::Customer);
                SalesPrice.SETRANGE("Sales Code", InCustFilter);
                if SalesPrice.FINDLAST then begin
                    "Last Price Change Date" := SalesPrice."Starting Date";
                    //"Low Unit Price" := SalesPrice."Low Unit Price";
                    //"High Unit Price" := SalesPrice."High Unit Price";
                    //"Medium Unit Price" := SalesPrice."Medium Unit Price";
                    "Curr. Unit Price Starting Date" := SalesPrice."Starting Date";
                    "Curr. Unit Price Ending Date" := SalesPrice."Ending Date";
                end;


                //Find Last Lost Opportunity
                LastLostOpportunity.RESET;
                //SQLPerform
                LastLostOpportunity.SETCURRENTKEY("Sell-to Customer No.", Type, "No.");
                LastLostOpportunity.SETRANGE(Type, LastLostOpportunity.Type::Item);

                LastLostOpportunity.SETRANGE("Document Type", LastLostOpportunity."Document Type"::"Stock Status");
                LastLostOpportunity.SETRANGE("No.", "Item No.");
                LastLostOpportunity.SETRANGE("Sell-to Customer No.", InCustFilter);
                if LastLostOpportunity.FINDLAST then begin
                    "Last Lost Opportunity" := true;
                    "Last Reason Code" := LastLostOpportunity."Reason Code";
                    "Last Reason Code Comment" := LastLostOpportunity."Reason Code Comment";
                end;

                //Find Last Quoted Unit Price and related fields
                LastSalesPrice.RESET;
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
                LastSalesPrice.ASCENDING;
                //SQLPerform
                //LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.","Item No.","Document Date");
                LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Unit of Measure Code", "Document Type");
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
                LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::Quote);
                LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
                LastSalesPrice.SETRANGE("Item No.", "Item No.");
                LastSalesPrice.SETRANGE("Unit of Measure Code", "Base Unit of Measure");
                if LastSalesPrice.FINDLAST then begin
                    "Last Quoted Unit Price" := LastSalesPrice."Last Unit Price";
                    "Last Quoted UOM" := LastSalesPrice."Last Price UOM";
                    "Last Quoted Qty." := LastSalesPrice."Last Price Qty.";
                end else begin
                    "Last Quoted Unit Price" := 0;
                    "Last Quoted UOM" := '';
                    "Last Quoted Qty." := 0;
                end;

                //Find Last Invoiced Unit Price and related fields
                LastSalesPrice.RESET;
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
                LastSalesPrice.ASCENDING;
                //SQLPerform
                //LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.","Item No.","Document Date");
                LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Unit of Measure Code", "Document Type");
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
                LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::"Posted Sales Invoice");
                LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
                LastSalesPrice.SETRANGE("Item No.", "Item No.");
                LastSalesPrice.SETRANGE("Unit of Measure Code", "Base Unit of Measure");
                if LastSalesPrice.FINDLAST then begin
                    "Last Invoice Price" := LastSalesPrice."Last Unit Price";
                    "Last Invoiced Qty." := LastSalesPrice."Last Price Qty.";
                end else begin
                    "Last Invoice Price" := 0;
                    "Last Invoiced Qty." := 0;
                end;
                StyleTxtNew := 'Standard';
                LastSalesPrice.RESET;
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
                LastSalesPrice.ASCENDING;
                LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
                LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
                LastSalesPrice.SETRANGE("Item No.", "Item No.");
                LastSalesPrice.SETRANGE("Special Price", false);//TPZ2970
                if LastSalesPrice.FINDLAST then begin
                    "Last Unit Price" := LastSalesPrice."Last Unit Price";
                    //TOP010D KT ABCSI SSQQ Unit Price 07142015
                    StyleTxtNew := '';
                    if LastSalesPrice."Price Increase" then begin
                        "Post Increase Unit Price" := LastSalesPrice."Last Unit Price"; //EB
                        "Pre Increase Unit Price" := LastSalesPrice."Pre Increase Unit Price";//EB
                        StyleTxtNew := 'Attention'
                    end else
                        StyleTxtNew := 'Standard';
                    //<TPZ2651>
                    if LastSalesPrice.Scaled then
                        StyleTxtNew := 'Attention';
                    //</TPZ2651>
                    if ("Shortcut Dimension 5 Code" = 'I') or ("Shortcut Dimension 5 Code" = 'L') then
                        "Unit Price" := LastSalesPrice."Last Unit Price";
                    // "Last Unit Price" := LastSalesPrice."Last Unit Price";//utk
                    //TOP010D KT ABCSI SSQQ Unit Price 07142015
                    "Last Price UOM" := LastSalesPrice."Last Price UOM";
                    "Last Price Qty." := LastSalesPrice."Last Price Qty.";
                    "Last Price Date" := LastSalesPrice."Last Price Date";
                    "Last Price User ID" := LastSalesPrice."Last Price User ID";  //TOP010E KT ABCSI 07282015
                end else begin
                    "Last Unit Price" := 0;
                    "Last Price UOM" := '';
                    "Last Price Qty." := 0;
                    "Last Price Date" := 0D;
                    "Last Price User ID" := '';  //TOP010E KT ABCSI 07282015
                end;

                //TOP010D KT ABCSI SSQQ Unit Price 07142015
                if "Shortcut Dimension 5 Code" = 'E' then
                    "Unit Price" := "Recomm. Unit Price";
                //TOP010D KT ABCSI SSQQ Unit Price 07142015
            end;
        end;
        "Average Unit Cost" := GetAvgCostPerUnit("Item No.", "Unit Cost");//TPZ2881
    end;

    procedure UpdateSingleLine(LineLocation: Code[10]);
    begin

        if (StockStatusQuickQuote.GET("Item No.")) then begin
            "Current Qty." := StockStatusQuickQuote."Current Qty.";
            "Current UOM" := StockStatusQuickQuote."Current UOM";
            "Unit Price" := StockStatusQuickQuote."Unit Price";
            "Reason Code" := StockStatusQuickQuote."Reason Code";
            "Reason Code Comment" := StockStatusQuickQuote."Reason Code Comment";
            "Lost Opportunity Description" := StockStatusQuickQuote."Lost Opportunity Description";  //TOP230 KT ABCSI CRP 2 Fixes 06092015
            "Lost Opportunity" := StockStatusQuickQuote."Lost Opportunity";
            "Location Code" := LineLocation;
            "Order Date" := TODAY;
            //TOP230 KT ABCSI CRP 2 Fixes 05282015
            "Recomm. Unit Price" := StockStatusQuickQuote."Recomm. Unit Price";
            "Recomm. Multiplier" := StockStatusQuickQuote."Recomm. Multiplier";
            //TOP230 KT ABCSI CRP 2 Fixes 05282015
            //"Shortcut Dimension 5 Code" := CurrDivisionCodeFilter;
            "Sell-to Customer No." := InCustFilter;
            if Item.GET("Item No.") then begin
                Description := Item.Description;
                "Unit Cost" := Item."Unit Cost";
                ItemUnitPrice := Item."Unit Price";
                //"ABC Code" := Item."ABC Code"; //UTKARSH
                QtyPerUOM := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Current UOM");
                Item.SETRANGE("Location Filter");
                Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Purch. Order");
                "Total Qty. on Hand" := Item.Inventory / QtyPerUOM;
                Item.SETFILTER("Location Filter", "Location Code");
                Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Purch. Order");

                //<TPZ1675>
                "Quantity Available on Location" := (Item.Inventory - Item."Qty. on Sales Order") / QtyPerUOM;
                //"Quantity Available on Location" := ItemMgt.CalcQtyAvailable(Item) / QtyPerUOM;
                //<//TPZ1675>


                "Qty. on Hand" := Item.Inventory / QtyPerUOM;
                "Qty. on Purch. Order" := Item."Qty. on Purch. Order" / QtyPerUOM;
                "Qty. on Sales Order" := Item."Qty. on Sales Order" / QtyPerUOM;

                if (CompanyInformation."Location Code" <> '') and (Item3.GET("Item No.")) then begin
                    Item3.SETFILTER("Location Filter", CompanyInformation."Location Code");
                    Item3.CALCFIELDS(Inventory, "Qty. on Sales Order");
                    //<TPZ1675>
                    "Main Loc. Qty. Avail" := (Item3.Inventory - Item3."Qty. on Sales Order") / QtyPerUOM;
                    // "Main Loc. Qty. Avail" := ItemMgt.CalcQtyAvailable(Item3) / QtyPerUOM;
                    //<//TPZ1675>
                end else
                    CLEAR("Main Loc. Qty. Avail");
                //TOP230 KT ABCSI CRP 2 Fixes 05282015
                "Low Unit Price" := Item."Low Unit Price";
                "High Unit Price" := Item."High Unit Price";
                "Medium Unit Price" := Item."Medium Unit Price";
                //TOP230 KT ABCSI CRP 2 Fixes 05282015
            end;



            SalesPrice.RESET;
            SalesPrice.SETRANGE("Item No.", "Item No.");
            SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::Customer);
            SalesPrice.SETRANGE("Sales Code", InCustFilter);
            if SalesPrice.FINDLAST then begin
                "Last Price Change Date" := SalesPrice."Starting Date";
                //"Low Unit Price" := SalesPrice."Low Unit Price";
                //"High Unit Price" := SalesPrice."High Unit Price";
                //"Medium Unit Price" := SalesPrice."Medium Unit Price";
                "Curr. Unit Price Starting Date" := SalesPrice."Starting Date";
                "Curr. Unit Price Ending Date" := SalesPrice."Ending Date";
            end;


            //Find Last Quoted Unit Price and related fields
            LastSalesPrice.RESET;
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
            LastSalesPrice.ASCENDING;
            LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 End
            LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::Quote);
            LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
            LastSalesPrice.SETRANGE("Item No.", "Item No.");
            LastSalesPrice.SETRANGE("Unit of Measure Code", "Base Unit of Measure");
            if LastSalesPrice.FINDLAST then begin
                "Last Quoted Unit Price" := LastSalesPrice."Last Unit Price";
                "Last Quoted UOM" := LastSalesPrice."Last Price UOM";
                "Last Quoted Qty." := LastSalesPrice."Last Price Qty.";
            end else begin
                "Last Quoted Unit Price" := 0;
                "Last Quoted UOM" := '';
                "Last Quoted Qty." := 0;
            end;

            //Find Last Invoiced Unit Price and related fields
            LastSalesPrice.RESET;
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
            LastSalesPrice.ASCENDING;
            LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 End
            LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::"Posted Sales Invoice");
            LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
            LastSalesPrice.SETRANGE("Item No.", "Item No.");
            LastSalesPrice.SETRANGE("Unit of Measure Code", "Base Unit of Measure");
            if LastSalesPrice.FINDLAST then begin
                "Last Invoice Price" := LastSalesPrice."Last Unit Price";
                "Last Invoiced Qty." := LastSalesPrice."Last Price Qty.";
            end else begin
                "Last Invoice Price" := 0;
                "Last Invoiced Qty." := 0;
            end;

            //Find Last Unit Price and related fields
            LastSalesPrice.RESET;
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
            LastSalesPrice.ASCENDING;
            LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
            //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 End
            LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
            LastSalesPrice.SETRANGE("Item No.", "Item No.");
            if LastSalesPrice.FINDLAST then begin
                "Last Unit Price" := LastSalesPrice."Last Unit Price";
                "Last Price UOM" := LastSalesPrice."Last Price UOM";
                "Last Price Qty." := LastSalesPrice."Last Price Qty.";
                "Last Price Date" := LastSalesPrice."Last Price Date";
                "Last Price User ID" := LastSalesPrice."Last Price User ID";  //TOP010E KT ABCSI 07282015
            end else begin
                "Last Unit Price" := 0;
                "Last Price UOM" := '';
                "Last Price Qty." := 0;
                "Last Price Date" := 0D;
                "Last Price User ID" := '';  //TOP010E KT ABCSI 07282015
            end;
        end
        else begin
            if Item.GET("Item No.") then begin
                "Unit Cost" := Item."Unit Cost";
                ItemUnitPrice := Item."Unit Price";
                "Unit Price" := 0;
                "Order Date" := TODAY;
                "Current UOM" := Item."Sales Unit of Measure";
                //"ABC Code" := Item."ABC Code"; //UTKARSH
                QtyPerUOM := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Current UOM");
                Item.SETRANGE("Location Filter");
                Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Purch. Order");
                "Total Qty. on Hand" := Item.Inventory / QtyPerUOM;
                Item.SETRANGE("Location Filter", LineLocation);
                Item.CALCFIELDS(Inventory, "Qty. on Sales Order", "Qty. on Purch. Order");

                //<TPZ1675>
                "Quantity Available on Location" := (Item.Inventory - Item."Qty. on Sales Order") / QtyPerUOM;
                //"Quantity Available on Location" := ItemMgt.CalcQtyAvailable(Item) / QtyPerUOM;
                //</TPZ1675>

                "Qty. on Hand" := Item.Inventory / QtyPerUOM;
                "Qty. on Purch. Order" := Item."Qty. on Purch. Order" / QtyPerUOM;
                "Qty. on Sales Order" := Item."Qty. on Sales Order" / QtyPerUOM;
                ItemLead := Item."Lead Time Calculation";
                if (CompanyInformation."Location Code" <> '') and (Item3.GET("Item No.")) then begin
                    Item3.SETFILTER("Location Filter", CompanyInformation."Location Code");
                    Item3.CALCFIELDS(Inventory, "Qty. on Sales Order");
                    //<TPZ1675>
                    "Main Loc. Qty. Avail" := (Item3.Inventory - Item3."Qty. on Sales Order") / QtyPerUOM;
                    //"Main Loc. Qty. Avail" := ItemMgt.CalcQtyAvailable(Item3) / QtyPerUOM;
                    //</TPZ1675>
                end else
                    CLEAR("Main Loc. Qty. Avail");
                "Current Qty." := 0;
                BaseUOM := Item."Base Unit of Measure";
                "Location Code" := LineLocation;
                //"Shortcut Dimension 5 Code" := CurrDivisionCodeFilter;
                "Sell-to Customer No." := InCustFilter;
                "Vendor Item No." := Item."Vendor Item No.";

                //TOP230 KT ABCSI CRP 2 Fixes 05282015
                "Low Unit Price" := Item."Low Unit Price";
                "High Unit Price" := Item."High Unit Price";
                "Medium Unit Price" := Item."Medium Unit Price";
                //TOP230 KT ABCSI CRP 2 Fixes 05282015

                SalesPrice.RESET;
                SalesPrice.SETRANGE("Item No.", "Item No.");
                SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::Customer);
                SalesPrice.SETRANGE("Sales Code", InCustFilter);
                if SalesPrice.FINDLAST then begin
                    "Last Price Change Date" := SalesPrice."Starting Date";
                    //"Low Unit Price" := SalesPrice."Low Unit Price";
                    //"High Unit Price" := SalesPrice."High Unit Price";
                    //"Medium Unit Price" := SalesPrice."Medium Unit Price";
                    "Curr. Unit Price Starting Date" := SalesPrice."Starting Date";
                    "Curr. Unit Price Ending Date" := SalesPrice."Ending Date";
                end;


                //Find Last Quoted Unit Price and related fields
                LastSalesPrice.RESET;
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
                LastSalesPrice.ASCENDING;
                LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 End
                LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::Quote);
                LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
                LastSalesPrice.SETRANGE("Item No.", "Item No.");
                LastSalesPrice.SETRANGE("Unit of Measure Code", "Current UOM");
                if LastSalesPrice.FINDLAST then begin
                    "Last Quoted Unit Price" := LastSalesPrice."Last Unit Price";
                    "Last Quoted UOM" := LastSalesPrice."Last Price UOM";
                    "Last Quoted Qty." := LastSalesPrice."Last Price Qty.";
                end else begin
                    "Last Quoted Unit Price" := 0;
                    "Last Quoted UOM" := '';
                    "Last Quoted Qty." := 0;
                end;

                //Find Last Invoiced Unit Price and related fields
                LastSalesPrice.RESET;
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
                LastSalesPrice.ASCENDING;
                LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 End
                LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::"Posted Sales Invoice");
                LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
                LastSalesPrice.SETRANGE("Item No.", "Item No.");
                LastSalesPrice.SETRANGE("Unit of Measure Code", "Current UOM");
                if LastSalesPrice.FINDLAST then begin
                    "Last Invoice Price" := LastSalesPrice."Last Unit Price";
                    "Last Invoiced Qty." := LastSalesPrice."Last Price Qty.";
                end else begin
                    "Last Invoice Price" := 0;
                    "Last Invoiced Qty." := 0;
                end;

                //Find Last Unit Price and related fields
                LastSalesPrice.RESET;
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 Start
                LastSalesPrice.ASCENDING;
                LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
                //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04162015 End
                LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
                LastSalesPrice.SETRANGE("Item No.", "Item No.");
                if LastSalesPrice.FINDLAST then begin
                    "Last Unit Price" := LastSalesPrice."Last Unit Price";
                    "Last Price UOM" := LastSalesPrice."Last Price UOM";
                    "Last Price Qty." := LastSalesPrice."Last Price Qty.";
                    "Last Price Date" := LastSalesPrice."Last Price Date";
                    "Last Price User ID" := LastSalesPrice."Last Price User ID";  //TOP010E KT ABCSI 07282015
                end else begin
                    "Last Unit Price" := 0;
                    "Last Price UOM" := '';
                    "Last Price Qty." := 0;
                    "Last Price Date" := 0D;
                    "Last Price User ID" := '';  //TOP010E KT ABCSI 07282015
                end;
            end;
        end;
        "Average Unit Cost" := GetAvgCostPerUnit("Item No.", "Unit Cost"); //TPZ2881
    end;

    procedure CheckLostOpportunity();
    var
        "LostQuoteNo.": Code[10];
    begin
        QuickQuoteWorkSheet.RESET;
        QuickQuoteWorkSheet.SETCURRENTKEY("Location Code", Description, "Item No.", "Sell-To Customer No.");
        QuickQuoteWorkSheet.SETFILTER("Current Qty.", '<>%1', 0);
        QuickQuoteWorkSheet.SETFILTER("Lost Opportunity", '%1', true);
        if QuickQuoteWorkSheet.FIND('-') then
            repeat
                UpDateLostOpportunity(DocType::"Stock Status", "LostQuoteNo.", QuickQuoteWorkSheet."Line No." * 10000, QuickQuoteWorkSheet, QuickQuoteWorkSheet."Location Code");
            until QuickQuoteWorkSheet.NEXT = 0;
    end;

    procedure CalcTotal(var MultiOrder: Boolean) OrderTotal: Decimal;
    var
        OLocation: Code[10];
    begin
        CLEAR(OLocation);
        QuickQuoteWorkSheet.RESET;
        QuickQuoteWorkSheet.SETCURRENTKEY("Location Code", Description, "Item No.", "Sell-To Customer No.");
        QuickQuoteWorkSheet.SETFILTER("Current Qty.", '<>%1', 0);
        QuickQuoteWorkSheet.SETRANGE("Sell-To Customer No.", InCustFilter);
        if QuickQuoteWorkSheet.FIND('-') then
            repeat
                if OLocation = '' then
                    OLocation := QuickQuoteWorkSheet."Location Code"
                else
                    if QuickQuoteWorkSheet."Location Code" <> OLocation then MultiOrder := true;
                OLocation := QuickQuoteWorkSheet."Location Code";
                OrderTotal += QuickQuoteWorkSheet."Current Qty (Base)" * QuickQuoteWorkSheet."Unit Price";
            until QuickQuoteWorkSheet.NEXT = 0;
    end;

    procedure VerifySalesLine() HasLine: Boolean;
    begin
        StockStatusQuickQuote.SETFILTER("Lost Opportunity", '%1', false);
        HasLine := (StockStatusQuickQuote.COUNT <> 0);
    end;

    procedure FetchRecommFieldValues(ItemNo: Code[20]; CustNo: Code[20]);
    var
        LocalItem: Record Item;
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TSalesHeader: Record "Sales Header";
        TSalesLine: Record "Sales Line";
    begin
        if ItemNo = '' then
            exit;

        if CustNo = '' then
            exit;

        if "Shortcut Dimension 5 Code" = 'E' then begin //TOP010D KT ABCSI SSQQ Unit Price 07142015
                                                        //TOP230 KT ABCSI CRP 2 Fixes 05012015
            LocalItem.GET(ItemNo);
            SalesSetup.GET;
            SalesSetup.TESTFIELD("Temp Order Nos.");
            //TOP230 KT ABCSI CRP 2 Fixes 05012015
            TSalesHeader."Document Type" := TSalesHeader."Document Type"::Order;
            TSalesHeader.VALIDATE("No.", NoSeriesMgt.GetNextNo(SalesSetup."Temp Order Nos.", WORKDATE, true));//TOP230 KT ABCSI CRP 2 Fixes 05012015
            TSalesHeader.INSERT(true);
            TSalesHeader.SetHideValidationDialog(true);
            TSalesHeader.VALIDATE("Sell-to Customer No.", CustNo);
            TSalesHeader.VALIDATE("Shortcut Dimension 5 Code", CurrDivisionCodeFilter); //TOP10B KT ABCSI - SSQQ Division Code 07142015
            if TSalesHeader."Shortcut Dimension 5 Code" = '' then
                TSalesHeader.VALIDATE("Shortcut Dimension 5 Code", LocalItem."Shortcut Dimension 5 Code");
            TSalesHeader."Location Code" := "Location Code";
            TSalesHeader.VALIDATE("Order Date", TODAY);
            TSalesHeader.MODIFY(true);
            //END;

            TSalesLine.RESET;
            TSalesLine.SETCURRENTKEY("Document Type", "Document No.");
            TSalesLine.SETRANGE(TSalesLine."Document Type", TSalesHeader."Document Type");
            TSalesLine.SETRANGE(TSalesLine."Document No.", TSalesHeader."No.");
            if TSalesLine.FIND('+') then
                SalesLineNo := TSalesLine."Line No." + 10000
            else
                SalesLineNo := 10000;

            TSalesLine.INIT;
            TSalesLine."Document Type" := TSalesLine."Document Type"::Order;
            TSalesLine."Document No." := TSalesHeader."No.";
            TSalesLine."Line No." := SalesLineNo;
            TSalesLine.VALIDATE("Sell-to Customer No.", CustNo);
            TSalesLine.Type := TSalesLine.Type::Item;
            TSalesLine.VALIDATE("No.", ItemNo);
            TSalesLine.VALIDATE("Location Code", "Location Code");
            TSalesLine.Quantity := 1;
            TSalesLine.INSERT(true);

            "Recomm. Multiplier" := TSalesLine."Recomm. Multiplier";
            "Recomm. Unit Price" := TSalesLine."Recomm. Unit Price";
            "Unit Price" := TSalesLine."Recomm. Unit Price";

            TSalesHeader.DELETE(true);
            //TOP010D KT ABCSI SSQQ Unit Price 07142015
        end else begin
            LastSalesPrice.RESET;
            LastSalesPrice.ASCENDING;
            LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
            LastSalesPrice.SETRANGE("Sell-to Customer No.", InCustFilter);
            LastSalesPrice.SETRANGE("Item No.", "Item No.");
            LastSalesPrice.SETRANGE("Special Price", false);//TPZ2970
                                                            //<TPZ2729>
            LastSalesPrice.SETFILTER("Document Type", '<>%1&<>%2', LastSalesPrice."Document Type"::"Return Order", LastSalesPrice."Document Type"::"Credit Memo");
            //</TPZ2729>
            if LastSalesPrice.FINDLAST then begin
                "Last Unit Price" := LastSalesPrice."Last Unit Price";
                "Last Price UOM" := LastSalesPrice."Last Price UOM";
                "Last Price Qty." := LastSalesPrice."Last Price Qty.";
                "Last Price Date" := LastSalesPrice."Last Price Date";
                "Last Price User ID" := LastSalesPrice."Last Price User ID";  //TOP010E KT ABCSI 07282015
            end else begin
                "Last Unit Price" := 0;
                "Last Price UOM" := '';
                "Last Price Qty." := 0;
                "Last Price Date" := 0D;
                "Last Price User ID" := '';  //TOP010E KT ABCSI 07282015
            end;
            "Unit Price" := "Last Unit Price";
        end;
        //TOP010D KT ABCSI SSQQ Unit Price 07142015
    end;

    procedure GetItemNo(): Code[20];
    begin
        // <TPZ820>
        exit("Item No.");
        // </TPZ820>
    end;

    procedure FilterByItemDescription(ItemDescriptionFilter: Text[50]);
    begin
        // <TPZ1055>
        if ItemDescriptionFilter <> '' then begin
            SETFILTER(Description, '*' + ItemDescriptionFilter + '*');
            if FIND('-') then;
            CurrPage.UPDATE(false);
            CurrPage.ACTIVATE(true);
        end else begin
            SETRANGE(Description);
            if FIND('-') then;
            CurrPage.UPDATE(false);
            CurrPage.ACTIVATE(true);
        end;
        // </TPZ1055>
    end;

    procedure FilterByItemDescription2(ItemDescription2Filter: Text[50]);
    begin
        // <TPZ1055>
        if ItemDescription2Filter <> '' then begin
            SETFILTER("Description 2", '*' + ItemDescription2Filter + '*');
            if FIND('-') then;
            CurrPage.UPDATE(false);
            CurrPage.ACTIVATE(true);
        end else begin
            SETRANGE("Description 2");
            if FIND('-') then;
            CurrPage.UPDATE(false);
            CurrPage.ACTIVATE(true);
        end;
        // </TPZ1055>
    end;

    local procedure UpdateUnitPrice();
    begin
        Newunitprice := (("Unit Price" * 5) / 100) + "Unit Price";
        VALIDATE("Unit Price", Newunitprice); //Ajay
        MESSAGE('%1', "Unit Price");
        MODIFY(true);
        CurrPage.UPDATE(false);
    end;

    local procedure SetStyleABC();
    var
        ItemABC: Record Item;
    begin
        //<TPZ2788>
        StyleTxtABC := '';
        ItemABC.RESET;
        if ItemABC.GET("Item No.") then begin
            case ItemABC."ABC Code" of
                'LS':
                    StyleTxtABC := 'favorable';
                'N':
                    StyleTxtABC := 'Standard';
                'A':
                    StyleTxtABC := 'Standard';
                'B':
                    StyleTxtABC := 'Standard';
                'C':
                    StyleTxtABC := 'Standard';
                'MD':
                    StyleTxtABC := 'Standard';
                'SO':
                    StyleTxtABC := 'Standard';
                'CL':
                    StyleTxtABC := 'Attention';
                'DI':
                    StyleTxtABC := 'Ambiguous';
                'OB':
                    StyleTxtABC := 'Strongaccent';
            end;
        end;
        //</TPZ2788>
    end;

    procedure GetAvgCostPerUnit(ItemNoPara: Code[20]; UnitCost: Decimal): Decimal;
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalCostPerUnit: Decimal;
        ItemLoc: Record Item;
        TotalRemainingQty: Decimal;
        NoOfEntry: Integer;
        AvgCostPerUnit: Decimal;
    begin
        ////TPZ2881 PSHUKLA new functionality for Avg Unit cost per location
        TotalCostPerUnit := 0;
        TotalRemainingQty := 0;
        NoOfEntry := 0;
        AvgCostPerUnit := 0;
        if ItemLoc.GET(ItemNoPara) then begin
            ItemLedgerEntry.RESET;
            ItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
            ItemLedgerEntry.SETRANGE("Item No.", ItemNoPara);
            ItemLedgerEntry.SETRANGE(Open, true);
            ItemLedgerEntry.SETFILTER("Location Code", '<>%1&<>%2', 'ONWATER', 'OWTRANSIT');
            if ItemLedgerEntry.FINDFIRST then
                repeat
                    //ItemLedgerEntry.CALCFIELDS("Cost per Unit", "Cost Amount (Actual)", "Cost Amount (Expected)");//TODO:
                    //TotalCostPerUnit += (ItemLedgerEntry."Cost per Unit" * ItemLedgerEntry."Remaining Quantity");
                    //TotalCostPerUnit += ItemLedgerEntry."Cost per Unit"; //Avg of cos per unit
                    if ItemLedgerEntry.Quantity > 0 then
                        TotalCostPerUnit += (((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)")
                                            / ItemLedgerEntry.Quantity) * ItemLedgerEntry."Remaining Quantity")
                    else
                        TotalCostPerUnit += ((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)")
                                             * ItemLedgerEntry."Remaining Quantity");
                    TotalRemainingQty += ItemLedgerEntry."Remaining Quantity";
                //NoOfEntry += 1;
                until ItemLedgerEntry.NEXT = 0;

            if TotalRemainingQty = 0 then
                TotalRemainingQty := 1;
            AvgCostPerUnit := ROUND(TotalCostPerUnit / TotalRemainingQty, 0.0001, '=');
            //IF AvgCostPerUnit = 0 THEN
            //AvgCostPerUnit := ROUND(UnitCost,0.0001,'=');
        end;
        exit(AvgCostPerUnit);
    end;
}

