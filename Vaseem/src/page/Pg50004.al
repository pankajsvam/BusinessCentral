page 50200 "Last Sales Prices"
{
    // version TOP070,TPZ2777,TPZ2970

    // TOP070 KT ABCSI Pricing History for Customers - Items 03122015
    //   - Created this page as part of this SMT
    // 
    // 2015-06-30 TPZ449 VCHERNYA
    //   Division Code (Shortcut Dimension 5 Code) and Country/Region Code field have been added
    // 2016-04-11 TPZ1482 TAKHMETO
    //   Customer Name and Item Description have been added
    // 2016-05-31 TPZ1340 EBAGIM
    //   Add Customer PO Number (External Doc No.) column
    // 2017-09-29 TPZ2000 EBAGIM
    //         Item Multiplier Group have been added
    // 2019-03-06 TPZ2501 Archive Last Sales Price table
    //   Added Page action "Archive Last Sales Price" for report SSRS Report "Archive Last Sales Price"
    // 2020-04-08 TPZ2777 DCleary - Changed Report directory to: User Reports - warehouse
    // TPZ2970 VAH 11252020 Added field : Special price

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Last Sales Price";


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("External Doc No."; "External Doc No.")
                {
                    Caption = 'Customer PO Number';
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Special Price"; "Special Price")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Last Unit Price"; "Last Unit Price")
                {
                }
                field("Last Price UOM"; "Last Price UOM")
                {
                }
                field("Last Price Qty."; "Last Price Qty.")
                {
                }
                field("Last Price Date"; "Last Price Date")
                {
                }
                field("Last Price User ID"; "Last Price User ID")
                {
                }
                field("Product Group Code"; "Product Group Code")
                {
                }
                field("Item Category Group"; "Item Category Group")
                {
                }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code")
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Item Multiplier Group"; "Item Multiplier Group")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Archive")
            {
                CaptionML = ENU = '&Archive',
                            ESM = '&Pedido',
                            FRC = 'C&ommande',
                            ENC = 'O&rder';
                Image = History;
                action("Archive Last Sales Price")
                {
                    Caption = 'Archive Last Sales Price';
                    Image = History;

                    trigger OnAction();
                    var
                        URL: Text[1000];
                    //HttpUtility : DotNet "'System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Web.HttpUtility";
                    begin
                        //<TPZ2501>,<TPZ2777>
                        //URL :=
                        //'http://nyvsvnavsql5/reportserver?/User%20Reports%20-%20IT/Achive%20Last%20Sales%20Price&rs:Command=Render&ItemNo=' +
                        //HttpUtility.UrlEncode("Item No.") +
                        //'&CustNo='+ HttpUtility.UrlEncode("Sell-to Customer No.");
                        //HYPERLINK(URL);
                        //</TPZ2501>
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        //<TPZ1340>
        "External Doc No." := '';
        if SalesHeader.GET("Document Type"::Order, "Document No.") then
            "External Doc No." := SalesHeader."External Document No."
        else begin
            SalesInvHeader.SETRANGE("No.", "Document No.");
            if SalesInvHeader.FINDFIRST then
                "External Doc No." := SalesInvHeader."External Document No.";
        end;
        //</TPZ1340>
    end;

    var
        "External Doc No.": Code[35];
}

