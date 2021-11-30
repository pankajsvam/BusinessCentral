page 50204 "Stock Status Wksh."
{
    Caption = 'Stock Status Wksh. AL';
    // version TOP010,TOPFIX,010B,010C,TPZHOTFIX,010E,170,RS1.04

    // TOP010 KT ABCSI Stock Status Quick Quote Screen 06042015
    //   - Created Stock Status Quick quote page
    //   - Renamed Action Lost Opportunity to Capture Lost Opportunity
    //   - Updated the default Sorting of the page in the SubPageView property of the Page Part Stock Status Quick Quote
    // 
    // TOP10B KT ABCSI - SSQQ Division Code 07082015
    //   - Division Code made non-editable
    //   - Added code under Division Code Filter OnValidate trigger
    // 
    // TOP10C KT ABCSI - SSQQ Item Search 07082015
    //   - Added a new field Item No. Filter
    // 
    // TOP10E KT ABCSI - Additional Stock Status 07282015
    //   - Added a new field Vendor Item No. Filter
    // 
    // TOP170 KT ABCSI - Sales Order Updates
    //   - Changed related to SSQQ to make it work when it is opened from Sales Quote/Order ribbon
    // 
    // 2015-06-11 TPZ699 VCHERNYA
    //   Item Units of Measure (Item Units of Measure FactBox) page part has been added
    // 2015-06-19 TPZ591 VCHERNYA
    //   Sorting has been changed to Sorting Order field in Stock Status Quick Quote page part
    // 2015-06-30 TPZ449 VCHERNYA
    //   Last Prices page action has been added
    // 2015-07-01 TPZ835 VCHERNYA
    //   Item Comments page part has been added
    // 2015-07-13 TPZ820 VCHERNYA
    //   Items by Location page action has been added
    // 2015-10-06 TPZ1055 VCHERNYA
    //   Description Filter and Description 2 Filter fields have been added
    // 2016-12-06 TPZ1546 EBAGIM
    //   Location code Override option was added
    // 2018.11.09 BUG2386 RIS  - revamp code to eliminate error failures

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Customer;
    UsageCategory = Tasks;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Editable = false;
                    HideValue = ESACC_F1_HideValue;
                    Visible = ESACC_F1_Visible;
                }
                field(LocationCode; LocationCode)
                {
                    Caption = 'Location Code';
                    Editable = LocCodeEditable;
                    Style = Standard;
                    StyleExpr = TRUE;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        GLSetup.GET;
                        if GLSetup."Shortcut Dimension 5 Code" = '' then
                            ERROR(ab005, GLSetup.TABLECAPTION);

                        CustDiv.RESET;
                        CustDiv.SETRANGE("Customer No.", "No.");
                        if PAGE.RUNMODAL(50007, CustDiv) = ACTION::LookupOK then begin
                            LocationCode := CustDiv."Location Code"
                        end;
                        RefreshLines
                    end;

                    trigger OnValidate();
                    begin
                        CustDiv.RESET;
                        CustDiv.SETRANGE("Customer No.", "No.");
                        CustDiv.SETRANGE("Location Code", LocationCode);
                        CustDiv.FINDFIRST;
                        RefreshLines;
                    end;
                }
                field(Blocked; Blocked)
                {
                    Editable = false;
                    HideValue = ESACC_F39_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F39_Visible;
                }
                field(Name; Name)
                {
                    Editable = false;
                    HideValue = ESACC_F2_HideValue;
                    QuickEntry = false;
                    Visible = ESACC_F2_Visible;
                }
                field("Division Code Filter"; DivisionCodeFilter)
                {
                    Editable = DivCodeEditable;
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        //TOP10B KT ABCSI - SSQQ Division Code 07132015
                        if not DivCodeEditable then
                            ERROR('You are not allowed to change Division Code \when this page is opened from Sales Quote/Order');

                        GLSetup.GET;
                        if GLSetup."Shortcut Dimension 5 Code" = '' then
                            GLSetup.FIELDERROR("Shortcut Dimension 5 Code");


                        UserSetup.GET(USERID);
                        if UserSetup."Shortcut Dimension 5 Filter" <> '' then begin
                            DimVal.RESET;
                            DimVal.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
                            DimVal.SETFILTER(Code, UserSetup."Shortcut Dimension 5 Filter");
                            if PAGE.RUNMODAL(0, DimVal) = ACTION::LookupOK then begin
                                DivisionCodeFilter := DimVal.Code;
                            end;
                        end else begin
                            DimVal.RESET;
                            DimVal.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 5 Code");
                            if PAGE.RUNMODAL(0, DimVal) = ACTION::LookupOK then begin
                                DivisionCodeFilter := DimVal.Code;
                            end;
                        end;

                        // if xDivisionCodeFilter <> DivisionCodeFilter then
                        //     CurrPage."Stock Status Quick Quote".PAGE.UserPrompt;//TODO:

                        xDivisionCodeFilter := DivisionCodeFilter;

                        RefreshLines;
                        //TOP10B KT ABCSI - SSQQ Division Code 07132015
                    end;

                    trigger OnValidate();
                    begin
                        //TOP10B KT ABCSI - SSQQ Division Code 07082015
                        if DivisionCodeFilter = '' then
                            ERROR('Division Code Filter can not be blank');

                        GLSetup.GET;
                        if not DimVal.GET(GLSetup."Shortcut Dimension 5 Code", DivisionCodeFilter) then
                            ERROR(ab006);

                        UserSetup.GET(USERID);
                        if UserSetup."Shortcut Dimension 5 Filter" <> '' then begin
                            if STRPOS(UserSetup."Shortcut Dimension 5 Filter", DivisionCodeFilter) = 0 then
                                ERROR(ab007, DivisionCodeFilter);
                        end;

                        // if xDivisionCodeFilter <> DivisionCodeFilter then
                        //     CurrPage."Stock Status Quick Quote".PAGE.UserPrompt;//TODO:

                        xDivisionCodeFilter := DivisionCodeFilter;
                        //TOP10B KT ABCSI - SSQQ Division Code 07082015

                        RefreshLines;
                    end;
                }
                field(LocationCodeOverride; LocationCodeOverride)
                {
                    Caption = 'Location Code Override';
                    TableRelation = Location WHERE("Shipping Location" = FILTER(true));

                    trigger OnValidate();
                    begin
                        //<TPZ1546>
                        RefreshLines;
                        //</TPZ1546>
                    end;
                }
            }
            group("Sales Document")
            {
                Caption = 'Sales Document';
                Visible = SalesGroupVisible;
                field(DocumentType; DocumentType)
                {
                    Caption = 'Document Type';
                    Editable = false;
                    QuickEntry = false;
                }
                field(DocumentNo; DocumentNo)
                {
                    Caption = 'Document No.';
                    Editable = false;
                    QuickEntry = false;
                }
            }
            group(Item)
            {
                Caption = 'Item';
                field(ItemNoFilter; ItemNoFilter)
                {
                    Caption = 'Item No. Filter';

                    trigger OnValidate();
                    begin
                        //TOP10C KT ABCSI - SSQQ Item Search 07082015
                        // CurrPage."Stock Status Quick Quote".PAGE.FindItemNo(ItemNoFilter);//TODO:
                        // CurrPage."Item FactBox".PAGE.UserUpdate; //VAH temp
                        //TOP10C KT ABCSI - SSQQ Item Search 07082015
                    end;
                }
                field(VendItemNoFilter; VendItemNoFilter)
                {
                    Caption = 'Vendor Item No. Filter';

                    trigger OnValidate();
                    begin
                        //TOP10E KT ABCSI - Additional Stock Status 07282015
                        // CurrPage."Stock Status Quick Quote".PAGE.FindVendItemNo(VendItemNoFilter);//TODO:
                        //CurrPage."Item FactBox".PAGE.UserUpdate; //VAH temp
                        //TOP10E KT ABCSI - Additional Stock Status 07282015
                    end;
                }
            }
            group("Item Description")
            {
                Caption = 'Item Description';
                Visible = false;
                field(DescriptionFilter; DescriptionFilter)
                {
                    Caption = 'Item Description Filter';

                    trigger OnValidate();
                    begin
                        // <TPZ1055>
                        // CurrPage."Stock Status Quick Quote".PAGE.FilterByItemDescription(DescriptionFilter);//TODO:
                        //CurrPage."Item FactBox".PAGE.UserUpdate; //VAH temp
                        // </TPZ1055>
                    end;
                }
                field(Description2Filter; Description2Filter)
                {
                    Caption = 'Item Description 2 Filter';

                    trigger OnValidate();
                    begin
                        // <TPZ1055>
                        //CurrPage."Stock Status Quick Quote".PAGE.FilterByItemDescription2(Description2Filter);//TODO:
                        //CurrPage."Item FactBox".PAGE.UserUpdate; //VAH temp
                        // </TPZ1055>
                    end;
                }
            }
            part("Stock Status Quick Quote"; "Stock Status Worksheet")
            {
                SubPageView = SORTING("Sorting Order")
                              ORDER(Ascending);
            }
        }
        area(factboxes)
        {
            part(Control1000000007; "Sales Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
            part(Control1000000008; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            // part("Item Attributes"; "Item Attribute Factbox2")
            // {
            //     Caption = 'Item Attributes';
            //     Provider = "Stock Status Quick Quote";
            //     SubPageLink = "No." = FIELD("Item No."),
            //                   "Table ID" = CONST(27);
            // }
            // part("Item FactBox"; "SSQQ Item FactBox")
            // {
            //     Provider = "Stock Status Quick Quote";
            //     SubPageLink = "Item No." = FIELD("Item No.");
            // }
            // part(Control1000000013; "Item Units of Measure FactBox")
            // {
            //     Provider = "Stock Status Quick Quote";
            //     SubPageLink = "Item No." = FIELD("Item No.");
            // }
            // part(Control1000000037; "Item Comments")
            // {
            //     Provider = "Stock Status Quick Quote";
            //     SubPageLink = "No." = FIELD("Item No.");
            // }
            systempart(Control1000000009; Links)
            {
            }
            systempart(Control1000000010; Notes)
            {
            }
            systempart(Control1000000011; MyNotes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Customer")
            {
                CaptionML = ENU = '&Customer',
                            ESM = '&Cliente',
                            FRC = '&Client',
                            ENC = '&Customer';
                Image = Customer;
                action("Find Customer")
                {
                    Enabled = ESACC_C1000000002_Enabled;
                    Image = Find;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+S';
                    Visible = ESACC_C1000000002_Visible;

                    trigger OnAction();
                    begin
                        CustRecLookup := Rec;
                        if PAGE.RUNMODAL(0, CustRecLookup) = ACTION::LookupOK then begin
                            CustNo := CustRecLookup."No.";
                            Rec := CustRecLookup;
                            Rec.FIND('=');
                            CurrPage.UPDATE(false);
                        end;
                    end;
                }
                action("Customer Card")
                {
                    Enabled = ESACC_C1000000029_Enabled;
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("No.");
                    RunPageMode = Edit;
                    ShortCutKey = 'Shift+F7';
                    Visible = ESACC_C1000000029_Visible;
                }
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                ESM = 'C&omentarios',
                                FRC = 'Co&mmentaires',
                                ENC = 'Co&mments';
                    Enabled = ESACC_C1000000094_Enabled;
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Customer),
                                  "No." = FIELD("No.");
                    Visible = ESACC_C1000000094_Visible;
                }
                group(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions',
                                ESM = 'Dimensiones',
                                FRC = 'Dimensions',
                                ENC = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        CaptionML = ENU = 'Dimensions-Single',
                                    ESM = 'Dimensiones-Individual',
                                    FRC = 'Dimensions - Simples',
                                    ENC = 'Dimensions-Single';
                        Enabled = ESACC_C1000000092_Enabled;
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(18),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        Visible = ESACC_C1000000092_Visible;
                    }
                    action("Dimensions-&Multiple")
                    {
                        CaptionML = ENU = 'Dimensions-&Multiple',
                                    ESM = 'Dimensiones-&Múltiple',
                                    FRC = 'Dimensions - &Multiples',
                                    ENC = 'Dimensions-&Multiple';
                        Enabled = ESACC_C1000000091_Enabled;
                        Image = DimensionSets;
                        Visible = ESACC_C1000000091_Visible;

                        trigger OnAction();
                        var
                            Cust: Record Customer;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SETSELECTIONFILTER(Cust);
                            // DefaultDimMultiple.SetMultiCust(Cust);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("Ship-&to Addresses")
                {
                    CaptionML = ENU = 'Ship-&to Addresses',
                                ESM = 'Di&rección envío',
                                FRC = '&Adresse (destinataire)',
                                ENC = 'Ship-&to Addresses';
                    Enabled = ESACC_C1000000088_Enabled;
                    Image = ShipAddress;
                    RunObject = Page "Ship-to Address List";
                    RunPageLink = "Customer No." = FIELD("No.");
                    Visible = ESACC_C1000000088_Visible;
                }
                action("C&ontact")
                {
                    CaptionML = ENU = 'C&ontact',
                                ESM = '&Contacto',
                                FRC = 'C&ontact',
                                ENC = 'C&ontact';
                    Enabled = ESACC_C1000000087_Enabled;
                    Image = ContactPerson;
                    Visible = ESACC_C1000000087_Visible;

                    trigger OnAction();
                    begin
                        ShowContact;
                    end;
                }
                action("Cross Re&ferences")
                {
                    CaptionML = ENU = 'Cross Re&ferences',
                                ESM = 'Referencias cru&zadas',
                                FRC = 'Ren&vois',
                                ENC = 'Cross Re&ferences';
                    Enabled = ESACC_C1000000086_Enabled;
                    Image = Change;
                    RunObject = Page "Cross References";
                    RunPageLink = "Cross-Reference Type" = CONST(Customer),
                                  "Cross-Reference Type No." = FIELD("No.");
                    RunPageView = SORTING("Cross-Reference Type", "Cross-Reference Type No.");
                    Visible = ESACC_C1000000086_Visible;
                }
                separator(Separator1000000077)
                {
                }
            }
            group(Documents)
            {
                CaptionML = ENU = 'Documents',
                            ESM = 'Documentos',
                            FRC = 'Documents',
                            ENC = 'Documents';
                Image = Documents;
                action("Order Summary")
                {
                    Caption = 'Show Order Summary';
                    Enabled = ESACC_C1000000028_Enabled;
                    Image = ViewWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = ESACC_C1000000028_Visible;

                    trigger OnAction();
                    begin

                        if "Location Code" = '' then begin
                            if (UserSetup.GET(USERID)) and (UserSetup."Default Location" <> '') then
                                "Location Code" := UserSetup."Default Location"
                            else
                                "Location Code" := "Location Code";
                        end;

                        CurrPage."Stock Status Quick Quote".PAGE.SetUserFilters("No.", "Location Code", DivisionCodeFilter);
                        CurrPage."Stock Status Quick Quote".PAGE.Refresh(NewCustQuote);
                        CurrPage."Stock Status Quick Quote".PAGE.ShowWorksheet;
                    end;
                }
                action(Quotes)
                {
                    CaptionML = ENU = 'Quotes',
                                ESM = 'Cotizaciones',
                                FRC = 'Devis',
                                ENC = 'Quotes';
                    Enabled = ESACC_C1000000062_Enabled;
                    Image = Quote;
                    RunObject = Page "Sales Quotes";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Sell-to Customer No.");
                    Visible = ESACC_C1000000062_Visible;
                }
                action(Orders)
                {
                    CaptionML = ENU = 'Orders',
                                ESM = 'Pedidos',
                                FRC = 'Commandes',
                                ENC = 'Orders';
                    Enabled = ESACC_C1000000061_Enabled;
                    Image = Document;
                    RunObject = Page "Sales Order List";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Sell-to Customer No.");
                    Visible = ESACC_C1000000061_Visible;
                }
                action("Return Orders")
                {
                    CaptionML = ENU = 'Return Orders',
                                ESM = 'Devoluciones',
                                FRC = 'Retours',
                                ENC = 'Return Orders';
                    Enabled = ESACC_C1000000060_Enabled;
                    Image = ReturnOrder;
                    RunObject = Page "Sales Return Order List";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Sell-to Customer No.");
                    Visible = ESACC_C1000000060_Visible;
                }
            }
            group("Related Info.")
            {
                Caption = 'Related Info.';
                Image = ReferenceData;
                action("Customer Order")
                {
                    Enabled = ESACC_C1000000016_Enabled;
                    Image = "Order";
                    RunObject = Page "Customer Order Header Status";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Sell-to Customer No.");
                    Visible = ESACC_C1000000016_Visible;
                }
                action("Customer Order Line Status")
                {
                    Enabled = ESACC_C1000000017_Enabled;
                    Image = Line;
                    RunObject = Page "Customer Order Lines Status";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Sell-to Customer No.");
                    Visible = ESACC_C1000000017_Visible;
                }
                action("Sales Invoice List")
                {
                    Enabled = ESACC_C1000000018_Enabled;
                    Image = Invoice;
                    RunObject = Page "Sales Invoice List";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Sell-to Customer No.");
                    Visible = ESACC_C1000000018_Visible;
                }
                action("Sales Credit Memos List")
                {
                    Enabled = ESACC_C1000000019_Enabled;
                    Image = CreditMemo;
                    RunObject = Page "Sales Credit Memos";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Sell-to Customer No.");
                    Visible = ESACC_C1000000019_Visible;
                }
            }
            group("Credit Mgt.")
            {
                Caption = 'Credit Mgt.';
                Image = AdministrationSalesPurchases;
                action("Credit Management")
                {
                    Enabled = ESACC_C1000000021_Enabled;
                    Image = Task;
                    RunObject = Page "Customer List - Credit Mgmt.";
                    RunPageLink = "No." = FIELD("No.");
                    RunPageView = SORTING("No.");
                    Visible = ESACC_C1000000021_Visible;
                }
            }
            group(History)
            {
                CaptionML = ENU = 'History',
                            ESM = 'Historial',
                            FRC = 'Historique',
                            ENC = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    CaptionML = ENU = 'Ledger E&ntries',
                                ESM = '&Movimientos',
                                FRC = 'É&critures comptables',
                                ENC = 'Ledger E&ntries';
                    Enabled = ESACC_C1000000075_Enabled;
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.");
                    ShortCutKey = 'Ctrl+F7';
                    Visible = ESACC_C1000000075_Visible;
                }
                action(Statistics)
                {
                    CaptionML = ENU = 'Statistics',
                                ESM = 'Estadísticas',
                                FRC = 'Statistiques',
                                ENC = 'Statistics';
                    Enabled = ESACC_C1000000074_Enabled;
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                    Visible = ESACC_C1000000074_Visible;
                }
                action("S&ales")
                {
                    CaptionML = ENU = 'S&ales',
                                ESM = 'Ve&ntas',
                                FRC = 'V&entes',
                                ENC = 'S&ales';
                    Enabled = ESACC_C1000000073_Enabled;
                    Image = Sales;
                    RunObject = Page "Customer Sales";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Visible = ESACC_C1000000073_Visible;
                }
                action("Entry Statistics")
                {
                    CaptionML = ENU = 'Entry Statistics',
                                ESM = 'Estadísticas documentos',
                                FRC = 'Statistiques écritures',
                                ENC = 'Entry Statistics';
                    Enabled = ESACC_C1000000072_Enabled;
                    Image = EntryStatistics;
                    RunObject = Page "Customer Entry Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    Visible = ESACC_C1000000072_Visible;
                }
            }
            group(ActionGroup1000000069)
            {
                CaptionML = ENU = 'S&ales',
                            ESM = 'Ve&ntas',
                            FRC = 'V&entes',
                            ENC = 'S&ales';
                Image = Sales;
                action("Invoice &Discounts")
                {
                    CaptionML = ENU = 'Invoice &Discounts',
                                ESM = 'Dto. &factura',
                                FRC = '&Escomptes facture',
                                ENC = 'Invoice &Discounts';
                    Enabled = ESACC_C1000000068_Enabled;
                    Image = CalculateInvoiceDiscount;
                    RunObject = Page "Cust. Invoice Discounts";
                    RunPageLink = Code = FIELD("Invoice Disc. Code");
                    Visible = ESACC_C1000000068_Visible;
                }
                action(Prices)
                {
                    CaptionML = ENU = 'Prices',
                                ESM = 'Precios',
                                FRC = 'Prix',
                                ENC = 'Prices';
                    Enabled = ESACC_C1000000067_Enabled;
                    Image = Price;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                    Visible = ESACC_C1000000067_Visible;
                }
                action("Line Discounts")
                {
                    CaptionML = ENU = 'Line Discounts',
                                ESM = 'Descuentos línea',
                                FRC = 'Ligne Escomptes',
                                ENC = 'Line Discounts';
                    Enabled = ESACC_C1000000066_Enabled;
                    Image = LineDiscount;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                    Visible = ESACC_C1000000066_Visible;
                }
                action("Last Prices")
                {
                    Caption = 'Last Prices';
                    Enabled = ESACC_C1000000036_Enabled;
                    Image = Price;
                    RunObject = Page "Last Sales Prices";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    Visible = ESACC_C1000000036_Visible;
                }
            }
        }
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                Image = RefreshLines;
                action("Refresh Lines")
                {
                    Enabled = ESACC_C1000000023_Enabled;
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = ESACC_C1000000023_Visible;

                    trigger OnAction();
                    begin
                        RefreshLines;
                    end;
                }
                action("Capture Lost Opportunity")
                {
                    Enabled = ESACC_C1000000032_Enabled;
                    Image = Opportunity;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = ESACC_C1000000032_Visible;

                    trigger OnAction();
                    begin

                        if CurrPage."Stock Status Quick Quote".PAGE.VerifySalesLine then begin
                            ERROR('There are items to process');
                            exit;
                        end;

                        CurrPage."Stock Status Quick Quote".PAGE.Refresh(true);
                    end;
                }
                action("Items b&y Location")
                {
                    Caption = 'Items b&y Location';
                    Enabled = ESACC_C1000000038_Enabled;
                    Image = ItemAvailbyLoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F11';
                    Visible = ESACC_C1000000038_Visible;

                    trigger OnAction();
                    var
                        StockStatusWkshLine: Record "Stock Status Wksh. Line";
                        MatrixRecord: Record Location;
                        MatrixRecords: array[32] of Record Location;
                        MatrixRecordRef: RecordRef;
                        // SSItemsByLocMtx: Page "S. S. Item Avail. by Loc. Mtx.";
                        MatrixMgt: Codeunit "Matrix Management";
                        UserSetupMgt: Codeunit "Codeunit5700EventSubscriber";
                        MATRIX_SetWanted: Option Initial,Previous,Same,Next;
                        MATRIX_CaptionSet: array[32] of Text[1024];
                        MATRIX_CaptionRange: Text[100];
                        MATRIX_PKFirstRecInCurrSet: Text[100];
                        MATRIX_CurrSetLength: Integer;
                        CaptionFieldNo: Integer;
                        CurrentMatrixRecordOrdinal: Integer;
                    begin
                        // <TPZ820>
                        MatrixRecord.SETRANGE("Use As In-Transit", false);
                        if UserSetupMgt.GetLocationFilter <> '' then       //EB Added Location Security FIlter
                            MatrixRecord.SETFILTER(Code, UserSetupMgt.GetLocationFilter);


                        CLEAR(MATRIX_CaptionSet);
                        CLEAR(MatrixRecords);
                        CurrentMatrixRecordOrdinal := 1;

                        MatrixRecordRef.GETTABLE(MatrixRecord);
                        MatrixRecordRef.SETTABLE(MatrixRecord);

                        CaptionFieldNo := MatrixRecord.FIELDNO(Code);

                        MatrixMgt.GenerateMatrixData(MatrixRecordRef, 0, ARRAYLEN(MatrixRecords), CaptionFieldNo, MATRIX_PKFirstRecInCurrSet,
                          MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrSetLength);

                        if MATRIX_CurrSetLength > 0 then begin
                            MatrixRecord.SETPOSITION(MATRIX_PKFirstRecInCurrSet);
                            MatrixRecord.FIND;
                            repeat
                                MatrixRecords[CurrentMatrixRecordOrdinal].COPY(MatrixRecord);
                                CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
                            until (CurrentMatrixRecordOrdinal > MATRIX_CurrSetLength) or (MatrixRecord.NEXT <> 1);
                        end;

                        StockStatusWkshLine.RESET;
                        //SSItemsByLocMtx.Load(MATRIX_CaptionSet,MatrixRecords,MatrixRecord); //VAH temp
                        /*   SSItemsByLocMtx.SETTABLEVIEW(StockStatusWkshLine);
                          if StockStatusWkshLine.GET(CurrPage."Stock Status Quick Quote".PAGE.GetItemNo) then
                              SSItemsByLocMtx.SETRECORD(StockStatusWkshLine);
                          SSItemsByLocMtx.RUNMODAL; */ //TODO:
                                                       // </TPZ820>
                    end;
                }
                action(AddtoDocument)
                {
                    Caption = 'Add to Document';
                    Enabled = ESACC_C1000000042_Enabled;
                    Image = Add;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = ESACC_C1000000042_Visible AND (AddtoDocumentActionVisible);

                    trigger OnAction();
                    begin
                        if DocumentNo = '' then
                            ERROR(ab008);

                        CurrPage."Stock Status Quick Quote".PAGE.NewOrderQuote(DocumentType, DocumentNo);  //TOP170 KT ABCSI Sales Order Updates 04012015
                    end;
                }
            }
        }
        area(creation)
        {
            action("Create Sales Order")
            {
                Enabled = ESACC_C1000000025_Enabled;
                Image = Document;
                Promoted = true;
                Visible = ESACC_C1000000025_Visible AND (SalesOrderActionVisible);

                trigger OnAction();
                begin
                    if DocumentNo <> '' then
                        ERROR(ab009);

                    CurrPage."Stock Status Quick Quote".PAGE.SetUserFilters("No.", "Location Code", DivisionCodeFilter);
                    CurrPage."Stock Status Quick Quote".PAGE.NewOrderQuote(0, '');
                end;
            }
            action("Create Sales Quote")
            {
                Enabled = ESACC_C1000000027_Enabled;
                Image = Quote;
                Promoted = true;
                Visible = ESACC_C1000000027_Visible AND (SalesQuoteActionVisible);

                trigger OnAction();
                begin
                    if DocumentNo <> '' then
                        ERROR(ab009);

                    CurrPage."Stock Status Quick Quote".PAGE.SetUserFilters("No.", "Location Code", DivisionCodeFilter);
                    CurrPage."Stock Status Quick Quote".PAGE.NewOrderQuote(1, '');
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        RefreshLines;
    end;

    trigger OnAfterGetRecord();
    begin
        if "No." <> xRec."No." then begin
            NewCustQuote := true;
            NewCust := true;
            CustNo := "No.";

            //TOPFIX KT ABCSI 06172015
            if not FromDocPage then begin
                if CustDiv.GET("No.", DivisionCodeFilter) then begin
                    if (CustDiv."Location Code" <> '') then
                        LocationCode := CustDiv."Location Code"
                    else
                        LocationCode := CompanyInformation."Location Code";
                end;
            end;
            //TOPFIX KT ABCSI 06172015
        end;

        // <TPZ820>
        // Commented out because it makes impossible to determine the current record that
        //   S. S. Item Avail. by Loc. Mtx. page should be opened at
        // RefreshLines;
        // </TPZ820>
    end;

    trigger OnOpenPage();
    begin

        if FromDocPage then begin
            FILTERGROUP := 2;
            SETRANGE("No.", CustRec."No.");
            FILTERGROUP := 0;
        end;

        ActivateFields;

        UserSetup.GET(USERID); //TOP010B KT ABCSI - SSQQ Division Code 07/13/2015
        //;ESACC_EasySecurity(true);
    end;

    var
        // ESACC_ESFLADSMgt: Codeunit "ES FLADS Management";
        [InDataSet]
        ESACC_C1000000002_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000002_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000016_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000016_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000017_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000017_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000018_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000018_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000019_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000019_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000021_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000021_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000023_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000023_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000025_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000025_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000027_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000027_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000028_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000028_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000029_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000029_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000032_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000032_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000036_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000036_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000038_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000038_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000042_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000042_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000060_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000060_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000061_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000061_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000062_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000062_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000066_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000066_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000067_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000067_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000068_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000068_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000072_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000072_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000073_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000073_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000074_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000074_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000075_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000075_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000086_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000086_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000087_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000087_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000088_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000088_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000091_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000091_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000092_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000092_Enabled: Boolean;
        [InDataSet]
        ESACC_C1000000094_Visible: Boolean;
        [InDataSet]
        ESACC_C1000000094_Enabled: Boolean;
        [InDataSet]
        ESACC_F1_Visible: Boolean;
        [InDataSet]
        ESACC_F1_Editable: Boolean;
        [InDataSet]
        ESACC_F1_HideValue: Boolean;
        [InDataSet]
        ESACC_F2_Visible: Boolean;
        [InDataSet]
        ESACC_F2_Editable: Boolean;
        [InDataSet]
        ESACC_F2_HideValue: Boolean;
        [InDataSet]
        ESACC_F39_Visible: Boolean;
        [InDataSet]
        ESACC_F39_Editable: Boolean;
        [InDataSet]
        ESACC_F39_HideValue: Boolean;
        ItemNoFilter: Code[20];
        VendItemNoFilter: Text[30];
        DescriptionFilter: Text[50];
        Description2Filter: Text[50];
        ToItemNo: Code[20];
        LocationCode: Code[10];
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesPrice: Record "Sales Price";
        StockStatusQuickQuote: Record "Stock Status Wksh. Line";
        QuickQuoteWorkSheet: Record "Quick Quote Worksheet Line";
        Item: Record Item;
        CommentLine: Record "Comment Line";
        UserSetup: Record "User Setup";
        CompanyInformation: Record "Company Information";
        SearchMethod: Option "1","2";
        SalesLineNo: Integer;
        NewCustQuote: Boolean;
        CustComm: array[3] of Text[80];
        DocPrint: Codeunit "Document-Print";
        ChangeLocation: Boolean;
        xLocation: Code[10];
        NewCust: Boolean;
        stockstatus: Record "Stock Status Wksh. Line" temporary;
        ItemRec: Record Item;
        MakeSubPageVisible: Boolean;
        DivisionCodeFilter: Code[20];
        xDivisionCodeFilter: Code[20];
        FromCustPage: Boolean;
        FromDocPage: Boolean;
        CustRec: Record Customer;
        CustNo: Code[20];
        CustRecLookup: Record Customer;
        CustPageList: Page "Customer List";
        Text0001: Label 'Customer No. Could not be found';
        CustDiv: Record "Customer Division";
        GLSetup: Record "General Ledger Setup";
        ab005: TextConst ENU = 'This Shortcut Dimension is not defined in the %1.', ESM = 'Este Shortcut de dimensión no está def. en el %1.', FRC = 'La dimension de ce raccourci n''est pas définie dans le %1.', ENC = 'This Shortcut Dimension is not defined in the %1.';
        CustDivFilter: Text;
        DimVal: Record "Dimension Value";
        DimMgt: Codeunit DimensionManagement;
        ab006: Label 'Dimension Code is not valid.';
        ab007: Label 'You are not authorized for the Division Code %1';
        DocumentNo: Code[20];
        DocumentType: Option "Order",Quote;
        LocCodeEditable: Boolean;
        DivCodeEditable: Boolean;
        ab008: Label 'Document No. is empty. Items cannot be added. \Please choose Create Sales Order or Create Sales Quote';
        ab009: Label 'Cannot create Sales Order or Sales Quote when Document No. exists. Please choose Add to Document';
        SalesOrderActionVisible: Boolean;
        SalesQuoteActionVisible: Boolean;
        AddtoDocumentActionVisible: Boolean;
        SalesGroupVisible: Boolean;
        JobName: Code[30];
        TPZJobName: Label 'Page Name Must be entered before creating a quote';
        LocationCodeOverride: Code[10];

    procedure RefreshLines();
    begin
        //TOPFIX KT ABCSI 06172015 Comment started
        /*
        IF ("Location Code" <> '') AND ("Location Code" <> xRec."Location Code") THEN
          ChangeLocation := TRUE
        ELSE
          ChangeLocation := FALSE;
        
        IF ChangeLocation THEN
          IF "Location Code" <> '' THEN
            LocationCode := "Location Code"
          ELSE
            LocationCode := CompanyInformation."Location Code";
        */
        //TOPFIX KT ABCSI 06172015 Comment ended
        //<TPZ1546>
        if LocationCodeOverride <> '' then
            LocationCode := LocationCodeOverride;
        //</TPZ1546>
        CurrPage."Stock Status Quick Quote".PAGE.SetUserFilters("No.", LocationCode, DivisionCodeFilter);
        CurrPage."Stock Status Quick Quote".PAGE.Refresh(NewCustQuote);

        //CurrPage."Item FactBox".PAGE.SetUserFilters(LocationCode); //VAH temp
        //CurrPage."Item FactBox".PAGE.UserUpdate; //NAH temp
        //CurrPage."Stock Status Quick Quote".PAGE.UserUpdate;
        NewCustQuote := false;
        NewCust := false;

    end;

    procedure SetFromCustPage(varFromCustPage: Boolean; varCustRec: Record Customer);
    begin
        FromCustPage := varFromCustPage;
        CustRec := varCustRec;
    end;

    procedure SetFromDocumentPage(varFromDocPage: Boolean; varCustRec: Record Customer; varDocType: Option "Order",Quote; varDocNo: Code[20]; varLocCode: Code[10]; varDivisionCodeFilter: Code[20]);
    begin
        FromDocPage := varFromDocPage;
        CustRec := varCustRec;
        DocumentType := varDocType;
        DocumentNo := varDocNo;
        LocationCode := varLocCode;
        DivisionCodeFilter := varDivisionCodeFilter;
    end;

    procedure SetDivisionCodeFilter(varDivisionCodeFilter: Code[20]);
    begin
        DivisionCodeFilter := varDivisionCodeFilter;
        xDivisionCodeFilter := varDivisionCodeFilter;
    end;

    procedure ActivateFields();
    begin
        LocCodeEditable := not FromDocPage;
        DivCodeEditable := not FromDocPage;
        SalesOrderActionVisible := not FromDocPage;
        SalesQuoteActionVisible := not FromDocPage;
        AddtoDocumentActionVisible := FromDocPage;
        SalesGroupVisible := FromDocPage;
    end;
}

