codeunit 50077 Table37EventSubscribers
{
    // version TPZ000.00.00,001,TPZ2881,003,004,TPZ2970,2993,008,3125,3247,010

    // 001 TPZ2891 RPS 07092020 - Replace Error on Item No. Validate on SO with Message
    // 002 TPZ2881 PKS 07232020  Added cod to calculate Gross Margin % Avg Cost
    // 003 TPZ2899 GKG 07272020 - Code added for 'Sales order Multiple'
    // 004 TPZ2970 VAH 11252020 - Code added in Function Tb37_UpdateLastSalesPrice
    // 001 TPZ2994 UTK 12032020 - Added function to get customer name in page 516
    // 005 TPZ2995 UTK 12172020 Added New Functions Tb37_GetLastSalesPrice_Quote and Tb37_GetLastSalesPriceDate_Quote.
    // 006 TPZ3016 UTK 02222021 Added new finctions Pg516_SalesHeaderCustPONo and Pg516_SalesHeaderStatus.
    // 006 TPZ3085 PKS 02172021  Added new code to show color from average unit cost field
    // 007 TPZ3125 PKS 03152021  Added code to flow Replacement Cost, Replacement Margin fields and update color coding
    // 008 TPZ3112 UTK 03242021  Added code to pop-up messsage fror Quality Return.
    // 009 TPZ3247 PKS 06292021 Added new logic on color coding of replacement cost field to show blue bold if replacement cost is zero on item card
    // 010 TPZ3344 UTK 10042021 Added code to update 'Stock Status Unit Price','Pre Inc Price','Post Inc Price' fields.


    trigger OnRun();
    begin
    end;
    /*
        var
            SalesHeader: Record "Sales Header";
            TPZGenLedgSetup: Record "General Ledger Setup";
            //Table36EventSubscribers : Codeunit Table36EventSubscribers;
            SuppressUpdateUnitPrice: Boolean;
            SuppressCheckItemAvailability: Boolean;
            TemporarySalesHeaderUsed: Boolean;
            Text0000: Label 'Sales Quote Line No. %1 must be same as Sales Line No. %2.';

        [EventSubscriber(ObjectType::Table, 37, 'OnBeforeInsertEvent', '', false, false)]
        local procedure Tb37_OnInsert(var Rec: Record "Sales Line"; RunTrigger: Boolean);
        begin
            if not RunTrigger then
                exit;
            //<TPZ2779>
            if (Rec."Document No." = '') and (Rec."Document Type" = Rec."Document Type"::"Return Order") then
                ERROR('Blank Document No. Is Not Allowed');
            //</TPZ2779>
        end;

        [EventSubscriber(ObjectType::Table, 37, 'OnBeforeModifyEvent', '', false, false)]
        local procedure Tb37_OnModify(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean);
        begin
            if not RunTrigger then
                exit;
            //<TPZ2583>
            //Tb37_CheckPackingStatus(Rec, xRec);
            //</TPZ2583>
            //<TPZ2779>
            if (Rec."Document No." = '') and (Rec."Document Type" = Rec."Document Type"::"Return Order") then
                ERROR('Blank Document No. Is Not Allowed');
            //</TPZ2779>
        end;

        [EventSubscriber(ObjectType::Table, 37, 'OnBeforeDeleteEvent', '', false, false)]
        procedure Tb37_OnDelete(var Rec: Record "Sales Line"; RunTrigger: Boolean);
        var
            recReasonCode: Record "Reason Code";
            SalesCommentLine: Record "Sales Comment Line";
            WarehouseRequest: Record "Warehouse Request";
        begin
            if not RunTrigger then
                exit;

            with Rec do begin
                TestStatusOpen;
                //<TPZ2583>
                // Tb37_CheckPackingStatus(Rec);
                if "Document Type" = "Document Type"::Order then begin
                    //IF Rec.Quantity < xRec.Quantity THEN BEGIN
                    WarehouseRequest.RESET;
                    WarehouseRequest.SETRANGE("Source Type", 37);
                    WarehouseRequest.SETRANGE("Source Document", WarehouseRequest."Source Document"::"Sales Order");
                    WarehouseRequest.SETRANGE("Source No.", "Document No.");
                    //WarehouseRequest.SETRANGE("Document Status",WarehouseRequest."Document Status"::Released);
                    WarehouseRequest.SETFILTER("Activity Status", '%1|%2|%3', WarehouseRequest."Activity Status"::"Pick Created",
                      WarehouseRequest."Activity Status"::"Pick Registered", WarehouseRequest."Activity Status"::Packed);
                    //WarehouseRequest.SETRANGE("Location Code","Location Code");
                    if not WarehouseRequest.ISEMPTY then
                        ERROR('Pick is Created For Sales Order %1', "Document No.");
                    //END;
                end;
                //</TPZ2583>
                if (("Document Type" = "Document Type"::Quote) or ("Document Type" = "Document Type"::Order)) and "Lost Opportunity" and ("Reason Code" = '') then
                    ERROR('Lost Opprtunity is True Please Fill Reason Code');
                //dekhna hai
                if recReasonCode.GET("Reason Code") then begin
                    if recReasonCode.Mandatory and "Lost Opportunity" and (("Document Type" = "Document Type"::Quote) or ("Document Type" = "Document Type"::Order)) then begin
                        SalesCommentLine.RESET;
                        SalesCommentLine.SETRANGE("Document Type", "Document Type");
                        SalesCommentLine.SETRANGE("No.", "Document No.");
                        SalesCommentLine.SETRANGE("Document Line No.", "Line No.");
                        if SalesCommentLine.ISEMPTY then
                            ERROR('Please Insert Sales Line Comments for Sales Order %1 Line No. %2', "Document No.", "Line No.");
                    end;
                end;

                //</TPZ2568>
                //TOP030B KT ABCSI Lost Opportunities 03092015
                if Type = Type::Item then
                    Tb37_UpdateLostOpportunity(Rec);
                //TOP030B KT ABCSI Lost Opportunities 03092015
            end;
        end;

        [EventSubscriber(ObjectType::Table, 37, 'OnAfterDeleteEvent', '', false, false)]
        procedure Tb37_OnDelete_1(var Rec: Record "Sales Line"; RunTrigger: Boolean);
        var
        //ChangeMgt: Codeunit "SC - Change Management"; dekhna hai
        begin
            if not RunTrigger then
                exit;

            //ChangeMgt.DeleteSalesLineRelatedData(Rec); // SC  <TPZ1925> dekhna hai
        end;

        [EventSubscriber(ObjectType::Table, 37, 'OnBeforeRenameEvent', '', false, false)]
        local procedure Tb37_OnRename(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean);
        begin
            if not RunTrigger then
                exit;

            if (Rec."Document No." = '') and (Rec."Document Type" = Rec."Document Type"::"Return Order") then
                ERROR('Blank Document No. Is Not Allowed');
        end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_No_Onvalidate', '', false, false)]
            procedure Tb37_No_OnValidate(var Sender: Codeunit Table37EventPublishers; var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; var HideValidationDialog: Boolean);
            var
                ItemRec: Record Item;
                ItemDivMatrix: Record "Item Division Matrix";
                UserSetupMgt: Codeunit "User Setup Management";
                Item2: Record Item;
                Text50000: Label 'You can enter items with Price Book Code %1 only.';
            begin
                GetSalesHeader_Event(Rec);
                with Rec do begin
                    if (xRec."No." <> "No.") and (Quantity <> 0) then begin
                        TESTFIELD("Qty. to Asm. to Order (Base)", 0);
                        CALCFIELDS("Reserved Qty. (Base)");
                        TESTFIELD("Reserved Qty. (Base)", 0);
                        if Type = Type::Item then
                            Tb37_CheckQtyRounding(Rec, HideValidationDialog); //TPZ9429
                    end;


                    //TOP130 KT ABCSI Item List Sort and Filter by Status 04092015 Start
                    if (xRec."No." <> "No.") and ("No." <> '') then begin
                        if Type = Type::Item then begin
                            ItemRec.RESET;
                            ItemRec.SETRANGE("No.", "No.");
                            if (not SalesHeader."Non Divisional") then begin
                                SalesHeader.TESTFIELD("Shortcut Dimension 5 Code");
                                if ItemDivMatrix.GET(SalesHeader."Shortcut Dimension 5 Code") then begin
                                    ItemRec.SETFILTER("Shortcut Dimension 5 Code", ItemDivMatrix."Divisional Filter");
                                    ItemRec.FINDFIRST;
                                end;
                            end else begin
                                ItemRec.SETRANGE("Shortcut Dimension 5 Code");
                                ItemRec.FINDFIRST;
                            end;
                            // <TOP8714>
                            if UserSetupMgt.GetPriceBookFilter <> '' then begin
                                Item2.RESET;
                                Item2.SETRANGE("No.", "No.");
                                Item2.SETFILTER("Price Book Code", UserSetupMgt.GetPriceBookFilter);
                                if not Item2.FINDFIRST then
                                    ERROR(Text50000, UserSetupMgt.GetPriceBookFilter);
                            end;
                            // </TOP8714>
                        end;
                    end;
                    //TOP130 KT ABCSI Item List Sort and Filter by Status 04092015 Start
                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterAssignGLAccountValues', '', false, false)]
            procedure Tb37_No_OnValidate_1(var SalesLine: Record "Sales Line"; GLAccount: Record "G/L Account");
            begin
                // <TPZ92>
                SalesLine."Commission Payable" := GLAccount."Commission Payable";
                // </TPZ92>
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterAssignItemValues', '', false, false)]
            procedure Tb37_No_OnValidate_2(var SalesLine: Record "Sales Line"; Item: Record Item);
            var
                SalesSetup: Record "Sales & Receivables Setup";
                CustMfrRepExcp: Record "Customer Mfr. Rep. Exception";
                Text51000: Label '%1 exists for %2 %3 that doesn''t allow to have different Mfr. Reps. on the same order.';
                CustDivision: Record "Customer Division";
                Location: Record Location;
                LastSalesPrice: Record "Last Sales Price";
                StockStatusWkshLine: Record "Stock Status Wksh. Line";
            begin
                GetSalesHeader_Event(SalesLine);
                with SalesLine do begin
                    GetSalesSetup;
                    SalesSetup.GET;//Utk
                    if SalesSetup."Validate Cust. Mfr. Rep. Exc." then begin
                        //<TPZ1390>
                        //SalesLineLoc.RESET;
                        //SalesLineLoc.SETRANGE("Document Type",SalesHeader."Document Type");
                        //SalesLineLoc.SETRANGE("Document No.",SalesHeader."No.");
                        //SalesLineLoc.SETFILTER("Line No.",'<>%1',"Line No.");
                        //SalesLineLoc.SETRANGE(Type,Type::Item);
                        //SalesLineLoc.SETFILTER("No.",'<>%1','');
                        //IF SalesLineLoc.FINDSET THEN
                        //REPEAT
                        //</TPZ1390>
                        CustMfrRepExcp.RESET;
                        CustMfrRepExcp.SETRANGE("Customer No.", "Sell-to Customer No.");
                        // <TPZ1274>
                        CustMfrRepExcp.SETFILTER("Mfr. Rep. Code", '<>%1', '');
                        // </TPZ1274>
                        if CustMfrRepExcp.FINDSET then
                            repeat
                                if ((Item."Manufacturer Code" = CustMfrRepExcp."Manufacturer Code") and
                                    (CustMfrRepExcp."Mfr. Rep. Code" <> SalesHeader."Mfr. Rep. Code")) or
                                   ((Item."Manufacturer Code" <> CustMfrRepExcp."Manufacturer Code") and
                                    (CustMfrRepExcp."Mfr. Rep. Code" = SalesHeader."Mfr. Rep. Code"))
                                then
                                    ERROR(
                                      Text51000,
                                      CustMfrRepExcp.TABLECAPTION,
                                      FIELDCAPTION("Sell-to Customer No."),
                                      "Sell-to Customer No.");
                            until CustMfrRepExcp.NEXT = 0;
                        //UNTIL SalesLineLoc.NEXT = 0;
                        // <TPZ1274>
                        if (Item."Manufacturer Code" <> '') and
                          CustMfrRepExcp.GET("Sell-to Customer No.", Item."Manufacturer Code")
                       then begin
                            // </TPZ1274>
                            if (SalesHeader."Mfr. Rep. Code" <> CustMfrRepExcp."Mfr. Rep. Code") then begin
                                // <TPZ1278>
                                //SalesHeader.SetSalesLineException("Document Type","Document No.","Line No.");
                                SalesHeader.VALIDATE("Mfr. Rep. Code", CustMfrRepExcp."Mfr. Rep. Code");
                                SalesHeader.MODIFY;
                                // SalesHeader.SetSalesLineException("Document Type"::Quote,'',0);
                                // </TPZ1278>
                            end;
                        end else begin
                            if CustDivision.GET(SalesHeader."Sell-to Customer No.", SalesHeader."Shortcut Dimension 5 Code") then begin
                                // <TPZ1278>
                                //SalesHeader.SetSalesLineException("Document Type","Document No.","Line No.");
                                // SalesHeader.SetSalesLineException("Document Type","Document No.","Line No.");
                                SalesHeader.VALIDATE("Mfr. Rep. Code", CustDivision."Mfr. Rep. Code");
                                SalesHeader.MODIFY;
                                // SalesHeader.SetSalesLineException("Document Type"::Quote,'',0);
                                // </TPZ1278>
                            end;
                        end;
                    end;
                    "Mfr. Rep. Code" := SalesHeader."Mfr. Rep. Code";
                    "ISR Code" := SalesHeader."ISR Code";
                    "CSR Code" := SalesHeader."CSR Code";
                    // </TPZ572>
                    // <TPZ92>
                    "Mfr. Rep. Comm. %" := SalesHeader."Mfr. Rep. Comm. %";
                    // </TPZ92>
                    "Alt. UOM Code" := Item."Alt. Sales Unit of Measure"; //TOP050 KT ABCSI Modification to Item Cards 01202015
                                                                          //<TPZ1047>
                                                                          // GetLocation("Location Code");
                    if "Location Code" = '' then
                        CLEAR(Location)
                    else
                        if Location.Code <> "Location Code" then
                            Location.GET("Location Code");

                    if Location.Code <> '' then begin
                        VALIDATE("Purchasing Code", Location."Default Purchasing Code");
                    end;
                    //</TPZ1047>
                    //<TPZ3344>
                    if (Type = Type::Item) and ("No." <> '') and ("Shortcut Dimension 5 Code" = 'L') then begin
                        LastSalesPrice.RESET;
                        LastSalesPrice.ASCENDING;
                        LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
                        LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::"Stock Status");
                        LastSalesPrice.SETRANGE("Sell-to Customer No.", "Sell-to Customer No.");
                        LastSalesPrice.SETRANGE("Item No.", "No.");
                        LastSalesPrice.SETRANGE("Special Price", false);
                        if LastSalesPrice.FINDLAST then begin
                            //"Last Unit Price" := LastSalesPrice."Last Unit Price";
                            if LastSalesPrice."Price Increase" then begin
                                "Post Price Inc." := LastSalesPrice."Last Unit Price";
                                "Pre Price inc." := LastSalesPrice."Pre Increase Unit Price";
                            end;
                            "Stock Status Unit Price" := LastSalesPrice."Last Unit Price";
                        end;


                        StockStatusWkshLine.RESET;
                        if StockStatusWkshLine.GET("No.") then begin
                            if "Pre Price inc." = 0 then
                                "Pre Price inc." := StockStatusWkshLine."Pre Increase Unit Price";
                            if "Post Price Inc." = 0 then
                                "Post Price Inc." := StockStatusWkshLine."Post Increase Unit Price";
                            if "Stock Status Unit Price" = 0 then
                                "Stock Status Unit Price" := StockStatusWkshLine."Unit Price";
                        end;
                    end;
                    //</TPZ3344>
                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterAssignItemChargeValues', '', false, false)]
            procedure Tb37_No_OnValidate_3(var SalesLine: Record "Sales Line"; ItemCharge: Record "Item Charge");
            begin
                with SalesLine do begin
                    // <TPZ1539>
                    "Commission Payable" := ItemCharge."Commission Payable";
                    // </TPZ1539>
                end;
            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_No_Onvalidate_1', '', false, false)]
            procedure Tb37_No_OnValidate_4(var Sender: Codeunit Table37EventPublishers; var Rec: Record "Sales Line");
            begin

                Rec.VALIDATE("Alt. UOM Code");  //TOP050 KT ABCSI Modification to Item Cards 01202015
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'No.', false, false)]
            procedure Tb37_No_OnValidate_5(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                TotalCostPerUnit: Decimal;
                ItemLoc: Record Item;
                TotalRemainingQty: Decimal;
                NoOfEntry: Integer;
            begin
                AvgCostPerLocation(Rec);
                GetAvgCostPerUnitPerLoc(Rec); //TPZ2993
                ReplacementCost(Rec);  //TPZ3125
                //
                //PSHUKLA new functionality for Avg Unit cost per location
                IF (Rec.Type = Rec.Type::Item) THEN BEGIN //AND (Rec."Location Code" <> '') THEN BEGIN
                  TotalCostPerUnit := 0;
                  TotalRemainingQty := 0;
                  NoOfEntry := 0;
                  ItemLoc.GET(Rec."No.");
                  ItemLedgerEntry.RESET;
                  ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
                  ItemLedgerEntry.SETRANGE("Item No.",Rec."No.");
                  ItemLedgerEntry.SETRANGE(Open,TRUE);
                  ItemLedgerEntry.SETFILTER("Location Code",'<>%1&<>%2','ONWATER','OWTRANSIT');
                  IF ItemLedgerEntry.FINDFIRST THEN
                    REPEAT
                      ItemLedgerEntry.CALCFIELDS("Cost per Unit");
                      //TotalCostPerUnit += (ItemLedgerEntry."Cost per Unit" * ItemLedgerEntry."Remaining Quantity");
                      TotalCostPerUnit += ItemLedgerEntry."Cost per Unit"; //Avg of cos per unit
                      TotalRemainingQty += ItemLedgerEntry."Remaining Quantity";
                      NoOfEntry += 1;
                    UNTIL ItemLedgerEntry.NEXT = 0;
                    {
                    IF TotalRemainingQty = 0 THEN
                      TotalRemainingQty := 1;
                     Rec."Average Unit Cost Per Loc" := ROUND(TotalCostPerUnit/TotalRemainingQty,0.0001,'=');
                     }
                    IF NoOfEntry = 0 THEN NoOfEntry := 1;  //Avg of cos per unit
                    Rec."Average Unit Cost Per Loc" := ROUND(TotalCostPerUnit/NoOfEntry,0.0001,'=');//Avg of cos per unit
                    IF Rec."Average Unit Cost Per Loc" = 0 THEN
                      Rec."Average Unit Cost Per Loc" := ROUND(Rec."Unit Cost (LCY)",0.0001,'=');
                END;


            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_No_OnLookup', '', false, false)]
            procedure Tb37_No_OnLookup(var Rec: Record "Sales Line");
            var
                "***ABCSI Locals***": Integer;
                StandardText: Record "Standard Text";
                GLAccount: Record "G/L Account";
                ItemRec: Record Item;
                ResourceRec: Record Resource;
                FixedAssetRec: Record "Fixed Asset";
                ItemChargeRec: Record "Item Charge";
                ItemDivMatrix: Record "Item Division Matrix";
            begin
                GetSalesHeader_Event(Rec);
                with Rec do begin
                    //TOP130 KT ABCSI Item List Sort and Filter by Status 04092015
                    TestStatusOpen;
                    //GetSalesHeader;
                    case Type of
                        Type::" ":
                            begin
                                if PAGE.RUNMODAL(8, StandardText) = ACTION::LookupOK then
                                    VALIDATE("No.", StandardText.Code);
                            end;
                        Type::Item:
                            begin
                                ItemRec.RESET;
                                if (not SalesHeader."Non Divisional") then begin
                                    SalesHeader.TESTFIELD("Shortcut Dimension 5 Code");
                                    ItemRec.FILTERGROUP(2);
                                    if ItemDivMatrix.GET(SalesHeader."Shortcut Dimension 5 Code") then
                                        ItemRec.SETFILTER("Shortcut Dimension 5 Code", ItemDivMatrix."Divisional Filter");
                                    ItemRec.FILTERGROUP(0);
                                end else
                                    ItemRec.SETRANGE("Shortcut Dimension 5 Code");
                                if ItemRec.GET("No.") then begin end;
                                if PAGE.RUNMODAL(31, ItemRec) = ACTION::LookupOK then
                                    VALIDATE("No.", ItemRec."No.");
                            end;
                        Type::"Fixed Asset":
                            begin
                                if PAGE.RUNMODAL(5601, FixedAssetRec) = ACTION::LookupOK then
                                    VALIDATE("No.", FixedAssetRec."No.");
                            end;
                        Type::"Charge (Item)":
                            begin
                                if PAGE.RUNMODAL(5800, ItemChargeRec) = ACTION::LookupOK then
                                    VALIDATE("No.", ItemChargeRec."No.");
                            end;
                        Type::"G/L Account":
                            begin
                                GLAccount.RESET;
                                if not "System-Created Entry" then begin
                                    GLAccount.FILTERGROUP(2);
                                    GLAccount.SETRANGE("Direct Posting", true);
                                    GLAccount.SETRANGE("Account Type", GLAccount."Account Type"::Posting);
                                    GLAccount.SETRANGE(Blocked, false);
                                    GLAccount.FILTERGROUP(2);
                                end;
                                if PAGE.RUNMODAL(18, GLAccount) = ACTION::LookupOK then
                                    VALIDATE("No.", GLAccount."No.");
                            end;
                        Type::Resource:
                            begin
                                if PAGE.RUNMODAL(77, ResourceRec) = ACTION::LookupOK then
                                    VALIDATE("No.", ResourceRec."No.");
                            end;
                    end;
                    //TOP130 KT ABCSI Item List Sort and Filter by Status 04092015

                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Description', false, false)]
            local procedure TB37_Description_OnValidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            begin
                WITH Rec DO BEGIN
                  IF (xRec."No." = '') AND ("No." <>'') THEN
                     VALIDATE("No.",'');
                END;


            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Location Code', false, false)]
            local procedure Tb37_LocationCode_OnValidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            begin
                //<TPZ2757>
                if Rec."Document Type" = Rec."Document Type"::"Return Order" then
                    Rec.TESTFIELD("Return Reason Code");
                //</TPZ2757>
            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_LocationCode_Onvalidate', '', false, false)]
            procedure Tb37_LocationCode_OnValidate_1(var Sender: Codeunit Table37EventPublishers; var Rec: Record "Sales Line");
            var
                Location: Record Location;
            begin
                with Rec do begin
                    //<TPZ1047>
                    if (Type = Type::Item) and ("No." <> '') then begin
                        //GetLocation("Location Code");
                        if "Location Code" = '' then
                            CLEAR(Location)
                        else
                            if Location.Code <> "Location Code" then
                                Location.GET("Location Code");

                        if Location.Code <> '' then
                            VALIDATE("Purchasing Code", Location."Default Purchasing Code");
                    end;
                    //</TPZ1047>
                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Location Code', false, false)]
            procedure Tb37_LocationCode_OnValidate_2(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            var
                LocationDivHdlgPct: Record "Location Division Hdlg. %";
            begin
                with Rec do begin
                    // <TPZ92>
                    if "Location Code" <> '' then begin
                        if "Location Code" <> LocationDivHdlgPct."Location Code" then
                            if not LocationDivHdlgPct.GET("Location Code", "Shortcut Dimension 5 Code") then
                                CLEAR(LocationDivHdlgPct);
                    end else
                        CLEAR(LocationDivHdlgPct);
                    // </TPZ92>

                    VALIDATE("Location Hdlg. %", LocationDivHdlgPct."Handling %");


                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Location Code', false, false)]
            procedure Tb37_LocationCode_OnValidate_3(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                TotalCostPerUnit: Decimal;
                ItemLoc: Record Item;
                TotalRemainingQty: Decimal;
            begin
                //PSHUKLA new functionality for Avg Unit cost per location
                AvgCostPerLocation(Rec);
                GetAvgCostPerUnitPerLoc(Rec); //TPZ2993
                ReplacementCost(Rec);  //TPZ3125

                IF (Rec.Type = Rec.Type::Item) AND (Rec."Location Code" <> '') THEN BEGIN
                  TotalCostPerUnit := 0;
                  TotalRemainingQty := 0;

                  ItemLoc.GET(Rec."No.");
                  ItemLedgerEntry.RESET;
                  ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
                  ItemLedgerEntry.SETRANGE("Item No.",Rec."No.");
                  ItemLedgerEntry.SETRANGE(Open,TRUE);
                  ItemLedgerEntry.SETRANGE("Location Code",Rec."Location Code");
                  IF ItemLedgerEntry.FINDFIRST THEN
                    REPEAT
                      ItemLedgerEntry.CALCFIELDS("Cost per Unit");
                      TotalCostPerUnit += (ItemLedgerEntry."Cost per Unit" * ItemLedgerEntry."Remaining Quantity");
                      TotalRemainingQty += ItemLedgerEntry."Remaining Quantity";
                    UNTIL ItemLedgerEntry.NEXT = 0;
                    IF TotalRemainingQty = 0 THEN
                      TotalRemainingQty := 1;
                    Rec."Average Unit Cost Per Loc" := ROUND(TotalCostPerUnit/TotalRemainingQty,0.0001,'=');
                    IF Rec."Average Unit Cost Per Loc" = 0 THEN
                      Rec."Average Unit Cost Per Loc" := ROUND(Rec."Unit Cost (LCY)",0.0001,'=');
                END;


            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_Quntity_OnValidate', '', false, false)]
            procedure Tb37_Quantity_OnValidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; var HideValidationDialog: Boolean; var CurrFieldNo: Integer);
            var
                ItemLedgEntry: Record "Item Ledger Entry";
                RoundedUpQty: Decimal;
                MinQty: Decimal;
                Item: Record Item;
                Text51078: Label 'Do you want to round the quantity up to %1 %2?';
                Text51080: Label 'cannot be more than %1 less %2 and %3';
                TextRNDERROR: Label '"You Must Round the Qty in order to sell this item %1 "';
                Text51500: Label 'In Sales Document %1, Line no. %2 you cannot change Quantity to less than %3 because total quantity in ship bin and being picked is %3.';
            begin
                with Rec do begin
                    //TestStatusOpen;
                    GetSalesHeader_Event(Rec);
                     IF NOT "System-Created Entry" THEN
                     IF Type <> Type::" " THEN
                       SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);

                    Tb37_CheckQtyRounding(Rec, HideValidationDialog);//TPZ9429
                                                                     // <TPZ69>
                    if GUIALLOWED and
                      ("Document Type" in ["Document Type"::Quote, "Document Type"::Order]) and
                       (Type = Type::Item) and
                       (CurrFieldNo = FIELDNO(Quantity)) and
                       (Quantity <> 0) and
                       Item.GET("No.") and
                       (Item."Sales Order Multiple" <> 0)
                       and (not Item."Override Sales Order Multiple")  //TPZ2899
                    then
                        if Quantity mod Item."Sales Order Multiple" <> 0 then begin
                            RoundedUpQty := Item."Sales Order Multiple" * (Quantity div Item."Sales Order Multiple" + 1);
                            if CONFIRM(Text51078, true, RoundedUpQty, "Unit of Measure Code") then
                                Quantity := RoundedUpQty
                            //<TPZ9429>
                            else
                                ERROR(TextRNDERROR, Item."No.");  //EB
                                                                  //</TPZ9429>
                        end;
                    // </TPZ69>

                    //TM BEG 070215 - Only allow user to change quantity if new quantity is more than total qty. picked + qty. in pick ticket.
                    if (Quantity <> xRec.Quantity) and ("Document Type" <> "Document Type"::Quote) then begin
                        MinQty := Tb37_CalcWhseMinQtyAllowToChangeTo(Rec);
                        if Quantity < MinQty then
                            ERROR(Text51500, "Document No.", "Line No.", MinQty);
                    end;
                    //TM END 070215

                    //TOP030B KT ABCSI Lost Opportunities 03112015
                    if Quantity <> 0 then
                        TESTFIELD("Reason Code", '');
                    //TOP030B KT ABCSI Lost Opportunities 03112015

                    //TOP050 KT ABCSI Modification to Item Cards 01212015
                    if "Alt. UOM Code" <> '' then
                        "Alt. UOM Quantity" := Tb37_CalcAltUOMQty(Rec, Quantity);
                    //TOP050 KT ABCSI Modification to Item Cards 01212015

                end;

            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Quantity', false, false)]
            procedure Tb37_Quantity_OnValidate_1(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            begin
                with Rec do begin
                    //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04142015 Start
                    if "Document Type" <> "Document Type"::Quote then begin  //TOP010E KT ABCSI 07282015
                        if Type = Type::Item then begin
                            if (xRec.Quantity <> Quantity) and (Quantity <> 0) and (CurrFieldNo = FIELDNO(Quantity)) then begin
                                Tb37_UpdateLastSalesPrice(Rec);
                            end;
                        end;
                    end; //TOP010E KT ABCSI 07282015
                         //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04142015 End

                    Tb37_UpdateMarginPercent(Rec); //TOP230 KT ABCSI CRP 2 Fixes 05282015
                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Quantity', false, false)]
            procedure Tb37_Quantity_OnValidate_2(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                TotalCostPerUnit: Decimal;
                ItemLoc: Record Item;
                TotalRemainingQty: Decimal;
                NoOfEntry: Integer;
            begin
                //PSHUKLA new functionality for Avg Unit cost per location
                AvgCostPerLocation(Rec);
                GetAvgCostPerUnitPerLoc(Rec); //TPZ2993
                ReplacementCost(Rec);  //TPZ3125
                //IF (Rec.Type = Rec.Type::Item) THEN BEGIN //AND (Rec."Location Code" <> '') THEN BEGIN
                  TotalCostPerUnit := 0;
                  TotalRemainingQty := 0;
                  NoOfEntry := 0;
                  ItemLoc.GET(Rec."No.");
                  ItemLedgerEntry.RESET;
                  ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
                  ItemLedgerEntry.SETRANGE("Item No.",Rec."No.");
                  ItemLedgerEntry.SETRANGE(Open,TRUE);
                  ItemLedgerEntry.SETFILTER("Location Code",'<>%1&<>%2','ONWATER','OWTRANSIT');
                  IF ItemLedgerEntry.FINDFIRST THEN
                    REPEAT
                      ItemLedgerEntry.CALCFIELDS("Cost per Unit");
                      //TotalCostPerUnit += (ItemLedgerEntry."Cost per Unit" * ItemLedgerEntry."Remaining Quantity");
                      TotalCostPerUnit += ItemLedgerEntry."Cost per Unit"; //Avg of cos per unit
                      TotalRemainingQty += ItemLedgerEntry."Remaining Quantity";
                      NoOfEntry += 1;
                    UNTIL ItemLedgerEntry.NEXT = 0;
                    {
                    IF TotalRemainingQty = 0 THEN
                      TotalRemainingQty := 1;
                     Rec."Average Unit Cost Per Loc" := ROUND(TotalCostPerUnit/TotalRemainingQty,0.0001,'=');
                     }
                    IF NoOfEntry = 0 THEN NoOfEntry := 1;  //Avg of cos per unit
                    Rec."Average Unit Cost Per Loc" := ROUND(TotalCostPerUnit/NoOfEntry,0.0001,'=');//Avg of cos per unit
                    IF Rec."Average Unit Cost Per Loc" = 0 THEN
                      Rec."Average Unit Cost Per Loc" := ROUND(Rec."Unit Cost (LCY)",0.0001,'=');
                END;


            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Qty. to Ship', false, false)]
            procedure Tb37_QuantitytoShip_OnValidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            begin

                Tb37_CheckQtyShipRounding(Rec);//<TPZ2504>
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Unit Price', false, false)]
            procedure Tb37_UnitPrice_Onvalidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            begin
                with Rec do begin
                    //TOP050 KT ABCSI Modification to Item Cards 01212015
                    if "Alt. UOM Code" <> '' then
                        "Alt. UOM Unit Price" := Tb37_CalcAltUOMUnitPrice(Rec, "Unit Price");
                    //TOP050 KT ABCSI Modification to Item Cards 01212015
                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Unit Price', false, false)]
            procedure Tb37_UnitPrice_Onvalidate_1(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            begin
                with Rec do begin
                    //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04142015 Start
                    if "Document Type" <> "Document Type"::Quote then begin  //TOP010E KT ABCSI 07282015
                        if Type = Type::Item then begin
                            if (xRec."Unit Price" <> "Unit Price") and ("Unit Price" <> 0) and (CurrFieldNo = FIELDNO("Unit Price")) then begin
                                Tb37_UpdateLastSalesPrice(Rec);
                            end;
                        end;
                    end; //TOP010E KT ABCSI 07282015
                         //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04142015 End

                    Tb37_UpdateMarginPercent(Rec); //TOP230 KT ABCSI CRP 2 Fixes 05282015

                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Unit Cost (LCY)', false, false)]
            procedure Tb37_UnitCostLCY_OnValidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            begin
                Tb37_UpdateMarginPercent(Rec); //TOP230 KT ABCSI CRP 2 Fixes 05282015
            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_LineDiscount%_OnValidate', '', false, false)]
            procedure "Tb37_LineDiscount%_OnValidate"(var Sender: Codeunit Table37EventPublishers; var Rec: Record "Sales Line"; CurrFieldNo: Integer; var Currency: Record Currency; var CalledFromActualUnitPrice: Boolean);
            begin
                with Rec do begin
                    // <TPZ1276>
                    "Line Discount Amount" :=
                      ROUND(
                        Quantity * "Unit Price",
                        Currency."Amount Rounding Precision") -
                      ROUND(
                        Quantity * ROUND("Unit Price" * (100 - "Line Discount %") / 100, Currency."Unit-Amount Rounding Precision"),
                        Currency."Amount Rounding Precision");
                    // </TPZ1276>

                    "Inv. Discount Amount" := 0;
                    "Inv. Disc. Amount to Invoice" := 0;

                    //TOP100A KT ABCSI Multipliers 02192015
                    if ((CurrFieldNo <> 0) and (CurrFieldNo <> FIELDNO("Actual Unit Price"))) or (CurrFieldNo = 0) then begin  //TOP230 KT ABCSI Topaz Fixes 07152015
                        if "Line Discount %" <> 0 then begin
                            // <TPZ1276>
                            Multiplier := ROUND(((100 - "Line Discount %") / 100), 0.0000001, '=');
                            // </TPZ1276>
                            if not CalledFromActualUnitPrice then
                                "Actual Unit Price" := ROUND(Multiplier * "Unit Price", 0.0001)  //TOP230 KT ABCSI Go Live Fixes 11092015
                            else
                                CLEAR(CalledFromActualUnitPrice);
                        end else begin
                            Multiplier := 0;
                            "Actual Unit Price" := ROUND("Unit Price", 0.0001);
                        end;
                    end;
                    if "Alt. UOM Code" <> '' then
                        "Alt. UOM Actual Unit Price" := Tb37_CalcAltUOMUnitPrice(Rec, "Actual Unit Price");
                    //TOP100A KT ABCSI Multipliers 02192015
                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Gen. Prod. Posting Group', false, false)]
            procedure Tb37_GenProdPostingGroup_OnValidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            var
                TPZText001: Label 'You cannot manually change %1: %2, when the %3 is sold as %4.';
                Item: Record Item;
            begin
                with Rec do begin
                    //<TPZ1682
                    if ((CurrFieldNo = FIELDNO("Gen. Prod. Posting Group")) and
                       (Type = Type::Item) and
                       (Sample or Promo) and //<TPZ2368>
                       ("Gen. Prod. Posting Group" <> xRec."Gen. Prod. Posting Group")) then
                        if Sample then
                            ERROR(TPZText001, FIELDCAPTION("Gen. Prod. Posting Group"), "Gen. Prod. Posting Group", Item.TABLECAPTION, FIELDCAPTION(Sample))
                        else
                            ERROR(TPZText001, FIELDCAPTION("Gen. Prod. Posting Group"), "Gen. Prod. Posting Group", Item.TABLECAPTION, FIELDCAPTION(Promo));//<TPZ2368>
                                                                                                                                                            //</TPZ1682>

                end;
            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_UnitOfMeasureCode_OnValidate', '', false, false)]
            procedure Tb37_UnitOfMeasureCode_OnValidate(var Sender: Codeunit Table37EventPublishers; var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            begin
                with Rec do begin
                    //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04142015 Start
                    if "Document Type" <> "Document Type"::Quote then begin  //TOP010E KT ABCSI 07282015
                        if (xRec."Unit of Measure Code" <> "Unit of Measure Code") and ("Unit of Measure Code" <> '') and (CurrFieldNo = FIELDNO("Unit of Measure Code")) then begin
                            Tb37_UpdateLastSalesPrice(Rec);
                        end;
                    end; //TOP010E KT ABCSI 07282015
                         //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04142015 End
                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Unit of Measure', false, false)]
            procedure Tb37_UnitOfMeasureCode_OnValidate_1(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                TotalCostPerUnit: Decimal;
                ItemLoc: Record Item;
                TotalRemainingQty: Decimal;
                NoOfEntry: Integer;
            begin
                //PSHUKLA new functionality for Avg Unit cost per location
                AvgCostPerLocation(Rec);
                GetAvgCostPerUnitPerLoc(Rec); //TPZ2993
                ReplacementCost(Rec);  //TPZ3125
                //IF (Rec.Type = Rec.Type::Item) THEN BEGIN //AND (Rec."Location Code" <> '') THEN BEGIN
                  TotalCostPerUnit := 0;
                  TotalRemainingQty := 0;
                  NoOfEntry := 0;
                  ItemLoc.GET(Rec."No.");
                  ItemLedgerEntry.RESET;
                  ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
                  ItemLedgerEntry.SETRANGE("Item No.",Rec."No.");
                  ItemLedgerEntry.SETRANGE(Open,TRUE);
                  ItemLedgerEntry.SETFILTER("Location Code",'<>%1&<>%2','ONWATER','OWTRANSIT');
                  IF ItemLedgerEntry.FINDFIRST THEN
                    REPEAT
                      ItemLedgerEntry.CALCFIELDS("Cost per Unit");
                      //TotalCostPerUnit += (ItemLedgerEntry."Cost per Unit" * ItemLedgerEntry."Remaining Quantity");
                      TotalCostPerUnit += ItemLedgerEntry."Cost per Unit"; //Avg of cos per unit
                      TotalRemainingQty += ItemLedgerEntry."Remaining Quantity";
                      NoOfEntry += 1;
                    UNTIL ItemLedgerEntry.NEXT = 0;
                    {
                    IF TotalRemainingQty = 0 THEN
                      TotalRemainingQty := 1;
                     Rec."Average Unit Cost Per Loc" := ROUND(TotalCostPerUnit/TotalRemainingQty,0.0001,'=');
                     }
                    IF NoOfEntry = 0 THEN NoOfEntry := 1;  //Avg of cos per unit
                    Rec."Average Unit Cost Per Loc" := ROUND(TotalCostPerUnit/NoOfEntry,0.0001,'=');//Avg of cos per unit
                    IF Rec."Average Unit Cost Per Loc" = 0 THEN
                      Rec."Average Unit Cost Per Loc" := ROUND(Rec."Unit Cost (LCY)",0.0001,'=');
                END;


            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Return Reason Code', false, false)]
            local procedure Tb_37_ReturnReasonCode_OnValidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            var
                Text0001: Label 'This is ''Sample'' Return line, Please check the Prices after entering Return Reason Code.';
            begin
                //<TPZ2850>
                with Rec do begin
                    if Sample then
                        MESSAGE(Text0001);
                end;
                //</TPZ2850>
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Return Reason Code', false, false)]
            procedure Tb37_ReturnReasonCode_OnValidate_1(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            var
                ReturnReason: Record "Return Reason";
                SalesCommentLine: Record "Sales Comment Line";
            begin
                with Rec do begin
                    //<TPZ2568>
                    if "Return Reason Code" <> xRec."Return Reason Code" then
                        if ReturnReason.GET("Return Reason Code") then
                            if ReturnReason.Mandatory then begin
                                //<TPZ3112>
                                if ("Document Type" = "Document Type"::"Return Order") and (ReturnReason.Type = ReturnReason.Type::Quality) then
                                    MESSAGE('Please Put QA Help Desk Ticket Number in Line Comment');
                                //</TPZ3112>
                                COMMIT;
                                SalesCommentLine.RESET;
                                SalesCommentLine.SETRANGE("Document Type", "Document Type");
                                SalesCommentLine.SETRANGE("No.", "Document No.");
                                SalesCommentLine.SETRANGE("Document Line No.", "Line No.");
                                if SalesCommentLine.ISEMPTY then
                                    ShowLineComments;
                            end;
                    //</TPZ2568>
                end;
            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_GetSalesHeader_Function', '', false, false)]
            procedure Tb37_GetSalesHeader(var Rec: Record "Sales Line");
            var
                Currency: Record Currency;
            begin
                with Rec do begin
                    if ("Document Type" <> SalesHeader."Document Type") or ("Temp Sales Order No." <> SalesHeader."No.") then begin
                        SalesHeader.GET("Document Type", "Temp Sales Order No.");
                        if SalesHeader."Currency Code" = '' then
                            Currency.InitRoundingPrecision
                        else begin
                            SalesHeader.TESTFIELD("Currency Factor");
                            Currency.GET(SalesHeader."Currency Code");
                            Currency.TESTFIELD("Amount Rounding Precision");
                        end;
                    end;
                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterUpdateUnitPrice', '', false, false)]
            procedure Tb37_UpdateUnitPrice(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer);
            var
                GotSalesPrice: Boolean;
                GotHotSheetPrice: Boolean;
                PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
                CustDivision: Record "Customer Division";
                Division: Record Division;
            begin
                //PSHUKLA CODECOVERAGEINCLUDE commented
                GetSalesHeader_Event(SalesLine);//Utkarsh
                WITH SalesLine DO BEGIN
                    CASE Type OF

                    //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04132015 Comment Start
                    {
                    Type::Item,Type::Resource:
                BEGIN
                        PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,Rec);
                        PriceCalcMgt.FindSalesLinePrice(SalesHeader,Rec,CalledByFieldNo);
                END;
                    }
                    //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04132015 Comment End
                    //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04132015 Start
                    Type::Item:
                BEGIN
                        CLEAR(GotSalesPrice);
                        CLEAR(GotHotSheetPrice);
                        //"Pricing Logic" := "Pricing Logic"::" "; //TOP230 KT ABCSI CRP 2 Fixes 06042015
                        PriceCalcMgt.FindSalesLineSalesPrice(SalesHeader,SalesLine,CalledByFieldNo);

                        IF "Pricing Logic" = "Pricing Logic"::"Sales Price" THEN GotSalesPrice := TRUE;


                        IF ("Pricing Logic" <> "Pricing Logic"::"Sales Price") THEN BEGIN
                          PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,SalesLine);
                          IF "Pricing Logic" = "Pricing Logic"::"Hot Sheet" THEN GotHotSheetPrice := TRUE;
                END;

                        IF (NOT GotSalesPrice) AND (NOT GotHotSheetPrice) THEN BEGIN
                          PriceCalcMgt.FindSalesLinePrice(SalesHeader,SalesLine,CalledByFieldNo);
                          //if "Unit price" <> 0 then "Pricing Logic" := "Pricing Logic"::"Item Unit Price";
                        END;


                        //TOP230 KT ABCSI CRP 2 Fixes 05282015
                        IF (NOT GotSalesPrice) AND (NOT GotHotSheetPrice) THEN
                          IF "Recomm. Multiplier" = 0 THEN BEGIN
                            IF CustDivision.GET(SalesHeader."Sell-to Customer No.",SalesHeader."Shortcut Dimension 5 Code") THEN BEGIN
                              IF CustDivision.Multiplier <> 0 THEN BEGIN
                                "Line Discount %" := ROUND((1 - CustDivision.Multiplier) * 100,0.00001); //TOP230 KT ABCSI Go Live Fixes 11092015
                                "Recomm. Multiplier" := CustDivision.Multiplier;
                                Multiplier := CustDivision.Multiplier;
                                "Pricing Logic" := "Pricing Logic"::"Customer Base Multiplier"; //TOP230 KT ABCSI CRP 2 Fixes 06022015
                              END;
                            END;
                          END;
                         //TOP230 KT ABCSI CRP 2 Fixes 05282015

                      END;

                    Type::Resource:
                BEGIN
                        PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,SalesLine);
                        PriceCalcMgt.FindSalesLinePrice(SalesHeader,SalesLine,CalledByFieldNo);
                      END;
                    //TOP180 KT ABCSI Customer Pricing - Hot Sheets 04132015 Start
                  END;
                  //TOP100A KT ABCSI Multipliers 02192015
                  CASE Type OF
                    Type::Item:
                    BEGIN
                        IF "Recomm. Multiplier" <> 0 THEN
                          "Recomm. Unit Price" := ROUND("Unit Price" * "Recomm. Multiplier",0.0001) //TOP230 KT ABCSI Go Live Fixes 11092015
                        ELSE
                          "Recomm. Unit Price" := "Unit Price";

                        IF Multiplier <> 0 THEN
                          "Actual Unit Price" := ROUND("Unit Price" * Multiplier,0.0001)  //TOP230 KT ABCSI Go Live Fixes 11092015
                        ELSE
                          "Actual Unit Price" := "Unit Price";

                        IF "Alt. UOM Code" <> '' THEN BEGIN
                          "Alt. UOM Actual Unit Price" := Tb37_CalcAltUOMUnitPrice(SalesLine,"Actual Unit Price");
                          "Alt. UOM Recomm. Unit Price" := Tb37_CalcAltUOMUnitPrice(SalesLine,"Recomm. Unit Price");
                    END;
                  END;
                  END;
                  //TOP100A KT ABCSI Multipliers 02192015

                  // <TPZ875>
                  IF ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order,"Document Type"::Invoice]) AND
                     (Type = Type::Item) AND
                     Division.GET(SalesHeader."Shortcut Dimension 5 Code") AND
                     Division."Use Last Price as Recomm Price"
                  THEN BEGIN
                    Tb37_GetLastSalesPrice(SalesLine);
                    "Line Discount %" := 0;
                    "Recomm. Multiplier" := 0;
                    Multiplier := 0;
                    "Unit Price" := "Last Unit Price";
                    "Recomm. Unit Price" := "Last Unit Price";
                    "Actual Unit Price" := "Last Unit Price";
                  END;
                  // </TPZ875>

                  VALIDATE("Unit Price");

                END;


            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_UpdateAmount_Function', '', false, false)]
            procedure Tb37_UpdateAmount(var Rec: Record "Sales Line");
            begin
                with Rec do begin
                    //<TPZ1375>

                    Tb37_UpdateMarginPercent(Rec);
                    //</TPZ1375>

                    // <TPZ92>
                    VALIDATE("Mfr. Rep. Comm. %");
                    VALIDATE("Location Hdlg. %");
                    ;
                    // </TPZ92>
                end;
            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_ShowDimensions_Function', '', false, false)]
            procedure Tb37_ShowDimensions(var Rec: Record "Sales Line");
            var
                DimMgt: Codeunit DimensionManagement;
                Codeunit408EventSubscriber: Codeunit Codeunit408EventSubscriber;
                OldDimSetID: Integer;
                ATOLink: Record "Assemble-to-Order Link";
            begin
                with Rec do begin
                    OldDimSetID := "Dimension Set ID";
                    "Dimension Set ID" :=
                    DimMgt.EditDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2 %3', "Document Type", "Document No.", "Line No."));
                    //VerifyItemLineDim;
                    if IsShippedReceivedItemDimChanged then
                        ConfirmShippedReceivedItemDimChange;
                    //TOP020 KT ABCSI Sales Orders by Division Code 01272015
                    //DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");  Commented Out for TOP020
                    Codeunit408EventSubscriber.Cu408_UpdateGlobalDimFromDimSetIDCustom("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 5 Code");
                    //TOP020 KT ABCSI Sales Orders by Division Code 01272015
                    ATOLink.UpdateAsmDimFromSalesLine(Rec);

                    if OldDimSetID <> "Dimension Set ID" then
                        MODIFY;
                end;

                COMMIT;
                ERROR('');
            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_CreateDim_Function', '', false, false)]
            procedure Tb37_CreateDim(var Rec: Record "Sales Line");
            var
                DimMgt: Codeunit DimensionManagement;
                Codeunit408EventSubscriber: Codeunit Codeunit408EventSubscriber;
            begin
                with Rec do begin
                    //TOP020 KT ABCSI Sales Orders by Division Code 01272015
                    //DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");  Commented Out for TOP020
                    Codeunit408EventSubscriber.Cu408_UpdateGlobalDimFromDimSetIDCustom("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shortcut Dimension 5 Code");
                    //TOP020 KT ABCSI Sales Orders by Division Code 01272015
                end;
            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_GetUnitCost_Function', '', false, false)]
            procedure Tb37_GetUnitCost(var Rec: Record "Sales Line"; var Item: Record Item);
            var
                UOMMgt: Codeunit "Unit of Measure Management";
            begin

                Rec."Qty. per Alt. UOM" := UOMMgt.GetQtyPerUnitOfMeasure(Item, Rec."Alt. UOM Code");  //TOP050 KT ABCSI Modification to Item Cards 01202015
            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_InitType_Function', '', false, false)]
            procedure Tb37_InitType(var Rec: Record "Sales Line"; var xRec: Record "Sales Line");
            begin
                with Rec do begin
                    GetSalesHeader_Event(Rec);
                    // <TPZ145>
                    if SalesHeader."Document Type" in [
                                                       SalesHeader."Document Type"::Quote,
                                                       SalesHeader."Document Type"::Order,
                                                       SalesHeader."Document Type"::"Return Order"]
                    then
                        Type := Type::Item
                    else
                        Type := xRec.Type;
                    // </TPZ145>
                end;
            end;

            [EventSubscriber(ObjectType::Codeunit, 50087, 'Table_37_InitHeaderDefault_Function', '', false, false)]
            procedure Tb37_InitHeaderDefault(var Rec: Record "Sales Line"; var SalesHeader1: Record "Sales Header");
            begin
                with Rec do begin
                    // <TPZ92>
                    "Mfr. Rep. Code" := SalesHeader1."Mfr. Rep. Code";
                    "Mfr. Rep. Comm. %" := SalesHeader1."Mfr. Rep. Comm. %";
                    "Location Hdlg. %" := SalesHeader1."Location Hdlg. %";
                    //TOP110 KT ABCSI Salesperson 04022015
                    VALIDATE("E-Ship Agent Code", SalesHeader1."Shipping Agent Code");
                    "E-Ship Agent Service" := SalesHeader1."E-Ship Agent Service";
                    //TOP110 KT ABCSI Salesperson 04022015
                end;
            end;

            procedure Tb37_UpdateLostOpportunity(var Rec: Record "Sales Line");
            var
                LostOpporunity: Record "Lost Opportunity";
            begin
                GetSalesHeader_Event(Rec);
                with Rec do begin
                    //TOP030B KT ABCSI Lost Opportunities 03092015
                    if ("Document Type" = "Document Type"::Order) or ("Document Type" = "Document Type"::Quote) then begin
                        if ("Lost Opportunity") then begin
                            if not LostOpporunity.GET("Document Type", "Document No.", "Line No.") then begin
                                LostOpporunity.INIT;
                                LostOpporunity."Document Type" := "Document Type";
                                LostOpporunity."Document No." := "Document No.";
                                LostOpporunity."Line No." := "Line No.";
                                LostOpporunity.INSERT;
                            end;
                            LostOpporunity."Sell-to Customer No." := "Sell-to Customer No.";
                            LostOpporunity.Type := LostOpporunity.Type::Item;
                            LostOpporunity."No." := "No.";
                            LostOpporunity."Location Code" := "Location Code";
                            LostOpporunity."Shipment Date" := "Shipment Date";
                            LostOpporunity."Unit of Measure Code" := "Unit of Measure Code";
                            if (LostOpporunity.Quantity = 0) and ("Outstanding Quantity" <> 0) then
                                LostOpporunity.Quantity := "Outstanding Quantity";
                            LostOpporunity."Quantity(Base)" := "Outstanding Qty. (Base)";
                            LostOpporunity."Unit Cost" := "Unit Cost (LCY)";
                            LostOpporunity."Actual Unit Price" := "Actual Unit Price";
                            LostOpporunity."Reason Code" := "Reason Code";
                            if "Reason Code Comment" <> '' then
                                LostOpporunity."Reason Code Comment" := "Reason Code Comment"
                            else begin
                                if "Document Type" = "Document Type"::Quote then
                                    LostOpporunity."Reason Code Comment" := SalesHeader."Your Reference";

                            end;
                            LostOpporunity."Lost Date" := TODAY;
                            LostOpporunity."User ID" := USERID;
                            LostOpporunity.MODIFY;
                        end;
                    end;
                    //TOP030B KT ABCSI Lost Opportunities 03092015
                end;
            end;

            procedure Tb37_CalcAltUOMQty(var rec: Record "Sales Line"; Qty: Decimal): Decimal;
            begin
                with rec do begin
                    //TOP050 KT ABCSI Modification to Item Cards 01212015
                    if "Qty. per Alt. UOM" <> 0 then begin
                        if "Qty. per Alt. UOM" <> "Qty. per Unit of Measure" then begin
                            if "Qty. per Alt. UOM" > "Qty. per Unit of Measure" then
                                exit(ROUND(Qty / "Qty. per Alt. UOM", 0.00001))
                            else
                                exit(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
                        end else
                            exit(Qty);
                    end else
                        exit(0);
                    //TOP050 KT ABCSI Modification to Item Cards 01212015
                end;
            end;

            procedure Tb37_CalcQtyFromAltUOMQty(var rec: Record "Sales Line"; Qty: Decimal): Decimal;
            begin
                with rec do begin
                    //TOP050 KT ABCSI Modification to Item Cards 01212015
                    if "Qty. per Alt. UOM" <> 0 then begin
                        if "Qty. per Alt. UOM" <> "Qty. per Unit of Measure" then begin
                            if "Qty. per Alt. UOM" > "Qty. per Unit of Measure" then
                                exit(ROUND(Qty * "Qty. per Alt. UOM", 0.00001))
                            else
                                exit(ROUND(Qty / "Qty. per Unit of Measure", 0.00001));
                        end else
                            exit(Qty);
                    end else
                        exit(0);
                    //TOP050 KT ABCSI Modification to Item Cards 01212015
                end;
            end;

            procedure Tb37_CalcAltUOMUnitPrice(var rec: Record "Sales Line"; UnitPrice: Decimal): Decimal;
            begin
                with rec do begin
                    //TOP050 KT ABCSI Modification to Item Cards 01212015
                    if "Qty. per Alt. UOM" <> 0 then begin
                        if "Qty. per Alt. UOM" <> "Qty. per Unit of Measure" then begin
                            if "Qty. per Alt. UOM" > "Qty. per Unit of Measure" then
                                exit(ROUND(UnitPrice * "Qty. per Alt. UOM", 0.0001)) //TOP230 KT ABCSI Go Live Fixes 11092015
                            else
                                exit(ROUND(UnitPrice / "Qty. per Unit of Measure", 0.0001)) //TOP230 KT ABCSI Go Live Fixes 11092015
                        end else
                            exit(UnitPrice);
                    end else
                        exit(0);
                    //TOP050 KT ABCSI Modification to Item Cards 01212015
                end;
            end;

            procedure Tb37_CalcUnitPriceFromAltUOMUnitPrice(var rec: Record "Sales Line"; UnitPrice: Decimal): Decimal;
            begin
                with rec do begin
                    //TOP050 KT ABCSI Modification to Item Cards 01212015
                    if "Qty. per Alt. UOM" <> 0 then begin
                        if "Qty. per Alt. UOM" <> "Qty. per Unit of Measure" then begin
                            if "Qty. per Alt. UOM" > "Qty. per Unit of Measure" then
                                exit(ROUND(UnitPrice / "Qty. per Alt. UOM", 0.0001)) //TOP230 KT ABCSI Go Live Fixes 11092015
                            else
                                exit(ROUND(UnitPrice * "Qty. per Unit of Measure", 0.0001)); //TOP230 KT ABCSI Go Live Fixes 11092015
                        end else
                            exit(UnitPrice);
                    end else
                        exit(0);
                    //TOP050 KT ABCSI Modification to Item Cards 01212015
                end;
            end;

            procedure Tb37_AutoFillQtyToOrder(var rec: Record "Sales Line"; var LocalSalesLine: Record "Sales Line");
            begin
                with rec do begin
                    //TOP030A KT ABCSI Sales Quotes 02132015
                    if "Document Type" = "Document Type"::Quote then begin
                        SETRANGE("Document Type", LocalSalesLine."Document Type");
                        SETRANGE("Document No.", LocalSalesLine."Document No.");
                        SETFILTER(Type, '<>%1', LocalSalesLine.Type::" ");
                        // <TPZ1067>
                        if FIND('-') then
                            repeat
                                CALCFIELDS("Qty. Ordered", "Qte. Qty. Invoiced");
                                "Qty. to Order" := Quantity - "Qty. Ordered" - "Qte. Qty. Invoiced";
                                MODIFY;
                            until NEXT = 0;
                        // </TPZ1067>
                    end;
                    //TOP030A KT ABCSI Sales Quotes 02132015
                end;
            end;

            procedure Tb37_DeleteQtyToOrder(var Rec: Record "Sales Line"; var LocalSalesLine: Record "Sales Line");
            begin
                with Rec do begin
                    //TOP030A KT ABCSI Sales Quotes 02132015
                    if "Document Type" = "Document Type"::Quote then begin
                        SETRANGE("Document Type", LocalSalesLine."Document Type");
                        SETRANGE("Document No.", LocalSalesLine."Document No.");
                        SETFILTER(Type, '<>%1', LocalSalesLine.Type::" ");
                        if FINDFIRST then
                            repeat
                                "Qty. to Order" := 0;
                                MODIFY;
                            until NEXT = 0;
                    end;
                    //TOP030A KT ABCSI Sales Quotes 02132015
                end;
            end;

            procedure Tb37_SetStyle(var rec: Record "Sales Line"): Text;
            var
                Item: Record Item;
            begin
                //-->TPZ3247
                with rec do begin
                    if (Type = Type::Item) and ("No." <> '') and (not Sample) then begin //EBAGIM Took of qty TPZ1125
                        Item.GET("No.");
                        if Item."Replacement Cost" = 0 then  //TPZ3247
                            exit('StrongAccent') //'Ambiguous' Subordinate //TPZ3247
                        else
                            if ("Actual Unit Price" <> "Recomm. Unit Price") and ("Actual Unit Price" > "Replacement Cost") then  //TOP230 KT ABCSI CRP 2 Fixes 05012015
                                exit('Favorable')
                            else
                                if ("Actual Unit Price" < "Replacement Cost") then
                                    exit('unFavorable')
                                else
                                    exit('');
                    end else
                        exit('');
                end;

                //-->TPZ3125 Code commented and written new code to check color from Replacement Cost
                WITH  rec DO BEGIN
                  IF (Type = Type::Item) AND ("No." <> '')  AND (NOT Sample) THEN BEGIN //EBAGIM Took of qty TPZ1125
                   Item.GET("No.");
                    IF ("Actual Unit Price" <> "Recomm. Unit Price") AND ("Actual Unit Price"> "Replacement Cost") THEN  //TOP230 KT ABCSI CRP 2 Fixes 05012015
                      EXIT('Favorable')
                    ELSE IF ("Actual Unit Price" < "Replacement Cost") THEN
                      EXIT('unFavorable')
                    ELSE EXIT('');
                  END ELSE
                    EXIT('');
                END;

                //<--TPZ3247
                //-->TPZ3085 Code commented and written new code to check color from Replacement Cost and average unit cost
                WITH  rec DO BEGIN
                  IF (Type = Type::Item) AND ("No." <> '')  AND (NOT Sample) THEN BEGIN //EBAGIM Took of qty TPZ1125
                   Item.GET("No.");
                    IF ("Actual Unit Price" <> "Recomm. Unit Price") AND ("Actual Unit Price"> Item."Average Unit Cost") THEN  //TOP230 KT ABCSI CRP 2 Fixes 05012015
                      EXIT('Favorable')
                    ELSE IF ("Actual Unit Price" < Item."Average Unit Cost") THEN
                      EXIT('unFavorable')
                    ELSE EXIT('');
                  END ELSE
                    EXIT('');
                END;


                WITH  rec DO BEGIN
                  IF (Type = Type::Item) AND ("No." <> '')  AND (NOT Sample) THEN BEGIN //EBAGIM Took of qty TPZ1125
                   Item.GET("No.");
                    IF ("Actual Unit Price" <> "Recomm. Unit Price") AND ("Actual Unit Price"> Item."Unit Cost") THEN  //TOP230 KT ABCSI CRP 2 Fixes 05012015
                      EXIT('Favorable')
                    ELSE IF ("Actual Unit Price" < Item."Unit Cost") THEN
                      EXIT('unFavorable')
                    ELSE EXIT('');
                  END ELSE
                    EXIT('');
                END;

                //<--TPZ3085
                SalesSetup.GET;// EBAGIM COMMENT OUT TPZ1125
                IF (SalesSetup."Sales Line Max. Margin %" <> 0) AND (SalesSetup."Sales Line Min. Margin %" <> 0) THEN BEGIN //TOP230 KT ABCSI CRP 2 Fixes 05012015
                  IF (Type = Type::Item) AND ("No." <> '')  AND (NOT Sample) THEN BEGIN //EB Tool of qty
                    Item.GET("No.");
                    IF ("Actual Unit Price" < (Item."Unit Cost" + ((Item."Unit Cost" * SalesSetup."Sales Line Min. Margin %")/100))) THEN  //TOP230 KT ABCSI CRP 2 Fixes 05012015
                      EXIT('Unfavorable')
                    ELSE IF ("Actual Unit Price" > (Item."Unit Cost" + ((Item."Unit Cost" * SalesSetup."Sales Line Max. Margin %")/100))) THEN
                      EXIT('Favorable')
                    ELSE EXIT('');
                  END ELSE
                    EXIT('');
                END ELSE
                  EXIT('');


            end;

            procedure Tb37_UpdateLastSalesPrice(var InRec: Record "Sales Line");
            var
                NewLastSalesPrice: Record "Last Sales Price";
                SalesHeaderLoc: Record "Sales Header";
            begin
                if InRec.Type <> InRec.Type::Item then
                    exit;
                //GetSalesHeader
                GetSalesHeader_Event(InRec);
                if InRec."Unit Price" = 0 then
                    exit;
                NewLastSalesPrice.RESET;
                NewLastSalesPrice.SETRANGE("Document Type", InRec."Document Type");
                NewLastSalesPrice.SETRANGE("Document No.", InRec."Document No.");
                NewLastSalesPrice.SETRANGE("Sell-to Customer No.", InRec."Sell-to Customer No.");
                NewLastSalesPrice.SETRANGE("Item No.", InRec."No.");
                NewLastSalesPrice.SETRANGE("Unit of Measure Code", InRec."Unit of Measure Code");
                if NewLastSalesPrice.FINDFIRST then begin
                    NewLastSalesPrice."Document Date" := SalesHeader."Document Date";
                    NewLastSalesPrice."Last Unit Price" := InRec."Actual Unit Price";
                    NewLastSalesPrice."Last Price UOM" := InRec."Unit of Measure Code";
                    NewLastSalesPrice."Last Price Qty." := InRec.Quantity;
                    NewLastSalesPrice."Last Price Date" := TODAY;
                    NewLastSalesPrice."Last Price User ID" := USERID;
                    NewLastSalesPrice."Special Price" := InRec."Special Price"; //TPZ2970
                    NewLastSalesPrice.MODIFY;
                end else begin
                    NewLastSalesPrice.INIT;
                    NewLastSalesPrice."Document Type" := InRec."Document Type";
                    NewLastSalesPrice."Document No." := InRec."Document No.";
                    // <TPZ1014>
                    NewLastSalesPrice.VALIDATE("Sell-to Customer No.", InRec."Sell-to Customer No.");
                    // </TPZ1014>
                    NewLastSalesPrice."Item No." := InRec."No.";
                    NewLastSalesPrice."Unit of Measure Code" := InRec."Unit of Measure Code";
                    NewLastSalesPrice."Document Date" := SalesHeader."Document Date";
                    NewLastSalesPrice."Last Unit Price" := InRec."Actual Unit Price";
                    NewLastSalesPrice."Last Price UOM" := InRec."Unit of Measure Code";
                    NewLastSalesPrice."Last Price Qty." := InRec.Quantity;
                    NewLastSalesPrice."Last Price Date" := TODAY;
                    NewLastSalesPrice."Last Price User ID" := USERID;
                    NewLastSalesPrice."Special Price" := InRec."Special Price"; //TPZ2970
                    // <TPZ449>
                    //IF SalesHeaderLoc.GET(InRec."Document Type",InRec."No.") THEN BEGIN
                    if SalesHeaderLoc.GET(InRec."Document Type", InRec."Document No.") then begin //<TPZ1603
                        NewLastSalesPrice."Shortcut Dimension 5 Code" := SalesHeaderLoc."Shortcut Dimension 5 Code";
                        NewLastSalesPrice."Country/Region Code" := SalesHeaderLoc."Sell-to Country/Region Code";
                    end;
                    // </TPZ449>
                    NewLastSalesPrice.INSERT;
                end;
            end;

            procedure Tb37_GetLastSalesPrice(var ToSalesLine: Record "Sales Line");
            var
                LastSalesPrice: Record "Last Sales Price";
            begin
                with ToSalesLine do begin
                    if ToSalesLine.Type <> ToSalesLine.Type::Item then
                        exit;
                    LastSalesPrice.RESET;
                    LastSalesPrice.ASCENDING;
                    LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
                    LastSalesPrice.SETRANGE("Sell-to Customer No.", ToSalesLine."Sell-to Customer No.");
                    LastSalesPrice.SETRANGE("Item No.", ToSalesLine."No.");

                    //<TPZ1081,TPZ8666>
                    //GetSalesHeader;
                    GetSalesHeader_Event(ToSalesLine);
                    if (SalesHeader."Shortcut Dimension 5 Code" = 'I') or (SalesHeader."Shortcut Dimension 5 Code" = 'E') or (SalesHeader."Shortcut Dimension 5 Code" = 'P') then //<TPZ2558>
                        LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::"Posted Sales Invoice");
                    //</TPZ1081,TPZ8666>
                    // <TPZ2974>
                    if SalesHeader."Shortcut Dimension 5 Code" = 'L' then
                        LastSalesPrice.SETFILTER("Document Type", '<>%1&<>%2', LastSalesPrice."Document Type"::"Return Order", LastSalesPrice."Document Type"::"Credit Memo");
                    //</TPZ2974>
                    if LastSalesPrice.FINDLAST then begin
                        "Last Unit Price" := LastSalesPrice."Last Unit Price";
                        "Last Price UOM" := LastSalesPrice."Last Price UOM";
                        "Last Price Qty." := LastSalesPrice."Last Price Qty.";
                        "Last Price Date" := LastSalesPrice."Last Price Date";
                    end else begin
                        "Last Unit Price" := 0;
                        "Last Price UOM" := '';
                        "Last Price Qty." := 0;
                        "Last Price Date" := 0D;
                    end;
                end;
            end;

            procedure Tb37_UpdateMarginPercent(var rec: Record "Sales Line");
            begin
                with rec do begin
                    //TOP230 KT ABCSI CRP 2 Fixes 05282015
                    if (Quantity <> 0) and ("Unit Cost" <> 0) and ("Actual Unit Price" <> 0) then begin
                        "Gross Margin %" := ROUND(((Quantity * "Actual Unit Price") - (Quantity * "Unit Cost")) * 100 / (Quantity * "Actual Unit Price"), 0.1);
                    end else
                        "Gross Margin %" := 0;

                    //TOP230 KT ABCSI CRP 2 Fixes 05282015
                    //-->TPZ2881
                    if (Quantity <> 0) and ("Average Unit Cost" <> 0) and ("Actual Unit Price" <> 0) then begin
                        "Gross Margin % Avg Cost" := ROUND(((Quantity * "Actual Unit Price") - (Quantity * "Average Unit Cost")) * 100 / (Quantity * "Actual Unit Price"), 0.1);
                        "Replacement Margin" := "Gross Margin % Avg Cost"; //36155
                    end else
                        "Gross Margin % Avg Cost" := 0;
                    //<--
                    //-->36155
                    if (Quantity <> 0) and ("Replacement Cost" <> 0) and ("Actual Unit Price" <> 0) then
                        "Replacement Margin" := ROUND(((Quantity * "Actual Unit Price") - (Quantity * "Replacement Cost")) * 100 / (Quantity * "Actual Unit Price"), 0.1);
                    //<--36155
                end;
            end;

            procedure Tb37_CalcWhseMinQtyAllowToChangeTo(var Rec: Record "Sales Line"): Decimal;
            var
                PickedQty: Decimal;
                PickQty: Decimal;
                OutboundReqMgt: Codeunit "Outbound Whse. Request Mgt.";
                PickedQtyBase: Decimal;
                PickQtyBase: Decimal;
            begin
                with Rec do begin
                    //TM BEG 070215
                    OutboundReqMgt.CaclTotalPickedQty(DATABASE::"Sales Line", "Document Type", "Document No.", "Line No.",
                                                      PickedQty, PickedQtyBase);

                    OutboundReqMgt.CaclTotalPickQty(DATABASE::"Sales Line", "Document Type", "Document No.", "Line No.",
                                                    PickQty, PickQtyBase, false);

                    //MESSAGE('%1,%2,%3',PickedQty,PickQty,"Qty. in Cross Dock");

                    exit(PickedQty + PickQty);
                end;
                //TM END 070215
            end;

            procedure Tb37_CopyLastUnitPriceToActualUnitPrice(var SalesLineLoc: Record "Sales Line");
            begin
                // <TPZ929>
                SalesLineLoc.RESET;
                SalesLineLoc.SETRANGE("Document Type", SalesLineLoc."Document Type");
                SalesLineLoc.SETRANGE("Document No.", SalesLineLoc."Document No.");
                SalesLineLoc.SETFILTER(Type, '<>%1', SalesLineLoc.Type::" ");
                if SalesLineLoc.FIND('-') then
                    repeat
                        SalesLineLoc.VALIDATE("Actual Unit Price", SalesLineLoc."Last Unit Price");
                        //<TPZ1125>//EBAGIM
                        SalesLineLoc."Unit Price Color" := Tb37_SetStyle(SalesLineLoc);
                        //<TPZ1125>
                        SalesLineLoc.MODIFY;
                    until SalesLineLoc.NEXT = 0;
                // </TPZ929>
            end;

            procedure Tb37_ClearActualUnitPrice(var SalesLineLoc: Record "Sales Line");
            begin
                // <TPZ929>
                SalesLineLoc.RESET;
                SalesLineLoc.SETRANGE("Document Type", SalesLineLoc."Document Type");
                SalesLineLoc.SETRANGE("Document No.", SalesLineLoc."Document No.");
                SalesLineLoc.SETFILTER(Type, '<>%1', SalesLineLoc.Type::" ");
                if SalesLineLoc.FIND('-') then
                    repeat
                        SalesLineLoc.VALIDATE("Actual Unit Price", 0);
                        SalesLineLoc.MODIFY;
                    until SalesLineLoc.NEXT = 0;
                // </TPZ929>
            end;

            procedure Tb37_CheckQtyRounding(var SalesLine: Record "Sales Line"; var HideValidationDialog: Boolean);
            var
                RoundedUpQty: Decimal;
                Item: Record Item;
                Text51078: Label 'Do you want to round the quantity up to %1 %2?';
                TextRNDERROR: Label '"You Must Round the Qty in order to sell this item %1 "';
            begin
                // <TPZ69>

                if GUIALLOWED then
                    with SalesLine do begin
                        //IF ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND  //<TPZ2521>
                        if ("Document Type" in ["Document Type"::Quote, "Document Type"::Order, "Document Type"::"Return Order"]) and  //</TPZ2521>
                         (Type = Type::Item) and
                         // (CurrFieldNo = FIELDNO(Quantity)) AND
                         (Quantity <> 0) and
                         Item.GET("No.") and
                         (Item."Sales Order Multiple" <> 0)
                         and (not Item."Override Sales Order Multiple")  //TPZ2899
                      then
                            if Quantity mod Item."Sales Order Multiple" <> 0 then begin
                                RoundedUpQty := Item."Sales Order Multiple" * (Quantity div Item."Sales Order Multiple" + 1);
                                if not HideValidationDialog then begin //<TPZ2682>
                                    if CONFIRM(Text51078, true, RoundedUpQty, "Unit of Measure Code") then
                                        Quantity := RoundedUpQty
                                    //<TPZ9429>
                                    else
                                        ERROR(TextRNDERROR, Item."No.");  //EB
                                                                          //</TPZ9429>
                                end else//<TPZ2682>
                                    Quantity := RoundedUpQty;//<TPZ2682>
                            end;
                    end;
                // </TPZ69>
            end;

            procedure Tb37_GetGLSetup();
            begin
                //<TPZ1682>
                TPZGenLedgSetup.GET;
                //</TPZ1682>
            end;

            procedure Tb37_SetGPPG_DIMForSampleLines(var pSampleSalesLine: Record "Sales Line");
            var
                TPZGenLedgSetup: Record "General Ledger Setup";
                Item: Record Item;
            begin
                //<TPZ1682>
                if pSampleSalesLine.Type <> pSampleSalesLine.Type::Item then
                    exit;
                GetSalesHeader_Event(pSampleSalesLine); // UTkarsh
                if pSampleSalesLine.Sample then begin
                    TPZGenLedgSetup.GET;
                    TPZGenLedgSetup.TESTFIELD("Sample Items GPPG Code");
                    TPZGenLedgSetup.TESTFIELD("Sample Items Expense G/L Acct.");
                    TPZGenLedgSetup.TESTFIELD("Sample Items GPPG Code");
                    TPZGenLedgSetup.TESTFIELD("Sample Department Code");
                    TPZGenLedgSetup.TESTFIELD("Sample Site Code");
                    pSampleSalesLine.VALIDATE("Gen. Prod. Posting Group", TPZGenLedgSetup."Sample Items GPPG Code");
                    pSampleSalesLine.VALIDATE("Shortcut Dimension 1 Code", TPZGenLedgSetup."Sample Department Code");
                    pSampleSalesLine.VALIDATE("Shortcut Dimension 2 Code", TPZGenLedgSetup."Sample Site Code");
                end else begin
                    //GetItem;
                    pSampleSalesLine.TESTFIELD("No.");
                    if pSampleSalesLine."No." <> Item."No." then
                        Item.GET(pSampleSalesLine."No.");

                    Item.TESTFIELD("Gen. Prod. Posting Group");
                    pSampleSalesLine.VALIDATE("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");
                    pSampleSalesLine.VALIDATE("Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
                    pSampleSalesLine.VALIDATE("Shortcut Dimension 2 Code", SalesHeader."Shortcut Dimension 2 Code");
                end;
                //</TPZ1682>
            end;

            procedure Tb37_SetGPPG_DIMForPromoLines(var pPromoSalesLine: Record "Sales Line");
            var
                TPZGenLedgSetup: Record "General Ledger Setup";
                Item: Record Item;
            begin
                //<TPZ2368>
                if pPromoSalesLine.Type <> pPromoSalesLine.Type::Item then
                    exit;
                GetSalesHeader_Event(pPromoSalesLine); // UTkarsh
                if pPromoSalesLine.Promo then begin
                    TPZGenLedgSetup.GET;
                    TPZGenLedgSetup.TESTFIELD("Promo Items GPPG Code");
                    TPZGenLedgSetup.TESTFIELD("Promo Items Expense G/L Acct.");
                    TPZGenLedgSetup.TESTFIELD("Promo Items GPPG Code");
                    TPZGenLedgSetup.TESTFIELD("Promo Department Code");
                    TPZGenLedgSetup.TESTFIELD("Promo Site Code");
                    pPromoSalesLine.VALIDATE("Gen. Prod. Posting Group", TPZGenLedgSetup."Promo Items GPPG Code");
                    pPromoSalesLine.VALIDATE("Shortcut Dimension 1 Code", TPZGenLedgSetup."Promo Department Code");
                    pPromoSalesLine.VALIDATE("Shortcut Dimension 2 Code", TPZGenLedgSetup."Promo Site Code");
                end else begin
                    //GetItem;
                    pPromoSalesLine.TESTFIELD("No.");
                    if pPromoSalesLine."No." <> Item."No." then
                        Item.GET(pPromoSalesLine."No.");
                    Item.TESTFIELD("Gen. Prod. Posting Group");
                    pPromoSalesLine.VALIDATE("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");
                    pPromoSalesLine.VALIDATE("Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
                    pPromoSalesLine.VALIDATE("Shortcut Dimension 2 Code", SalesHeader."Shortcut Dimension 2 Code");
                end;
                //</TPZ2368>
            end;

            procedure Tb37_CheckQtyShipRounding(var SalesLine: Record "Sales Line");
            var
                RoundedUpQtyShip: Decimal;
                Item: Record Item;
                Text51078: Label 'Do you want to round the quantity up to %1 %2?';
                TextRNDERROR: Label '"You Must Round the Qty in order to sell this item %1 "';
            begin
                // <TPZ2504>

                if GUIALLOWED then
                    with SalesLine do begin
                        if ("Document Type" in ["Document Type"::Quote, "Document Type"::Order]) and
                         (Type = Type::Item) and
                         // (CurrFieldNo = FIELDNO(Quantity)) AND
                         (Quantity <> 0) and
                         Item.GET("No.") and
                         (Item."Sales Order Multiple" <> 0)
                           and (not Item."Override Sales Order Multiple")  //TPZ2899
                      then
                            if "Qty. to Ship" mod Item."Sales Order Multiple" <> 0 then begin
                                RoundedUpQtyShip := Item."Sales Order Multiple" * ("Qty. to Ship" div Item."Sales Order Multiple" + 1);
                                if CONFIRM(Text51078, true, RoundedUpQtyShip, "Unit of Measure Code") then
                                    "Qty. to Ship" := RoundedUpQtyShip
                                //<TPZ9429>
                                else
                                    ERROR(TextRNDERROR, Item."No.");  //EB
                                                                      //</TPZ9429>
                            end;
                    end;
                // </TPZ2504>
            end;

            procedure Tb37_CheckPackingStatus(var Rec: Record "Sales Line"; var xRec: Record "Sales Line");
            var
                WarehouseRequest: Record "Warehouse Request";
            begin
                with Rec do begin
                    //<TPZ2583>
                    if "Document Type" = "Document Type"::Order then begin
                        if Rec.Quantity < xRec.Quantity then begin
                            WarehouseRequest.RESET;
                            WarehouseRequest.SETRANGE("Source Type", 37);
                            WarehouseRequest.SETRANGE("Source Document", WarehouseRequest."Source Document"::"Sales Order");
                            WarehouseRequest.SETRANGE("Source No.", "Document No.");
                            //WarehouseRequest.SETRANGE("Document Status",WarehouseRequest."Document Status"::Released);
                            WarehouseRequest.SETFILTER("Activity Status", '%1|%2|%3', WarehouseRequest."Activity Status"::"Pick Created",
                              WarehouseRequest."Activity Status"::"Pick Registered", WarehouseRequest."Activity Status"::Packed);
                            //WarehouseRequest.SETRANGE("Location Code","Location Code");
                            if not WarehouseRequest.ISEMPTY then
                                ERROR('Pick is Created For Sales Order %1', "Document No.");
                        end;
                    end;
                    //</TPZ2583>
                end;
            end;

            procedure Tb37_SetSuppressUpdateUnitPrice(UpdateUnitPrice: Boolean);
            begin
                // START,SC  <TPZ1925>
                SuppressUpdateUnitPrice := UpdateUnitPrice;
                // END,SC    </TPZ1925>
            end;

            procedure Tb37_SetSuppressCheckItmeAvail(CheckItemAvailability: Boolean);
            begin
                // START,SC   <TPZ1925>
                SuppressCheckItemAvailability := CheckItemAvailability;
                // END,SC     </TPZ1925>
            end;

            procedure Tb37_SetTemporarySalesHeader(useTemporarySalesHeader: Boolean);
            begin
                // START,SC    <TPZ1925>
                TemporarySalesHeaderUsed := useTemporarySalesHeader;
                // END,SC      </TPZ1925>
            end;

            procedure Tb37_IsTemporarySalesHeader() TemporarySalesHeaderUsed: Boolean;
            begin
                // START,SC   <TPZ1925>
                exit(TemporarySalesHeaderUsed);
                // END,SC     </TPZ1925>
            end;

            local procedure GetSalesHeader_Event(var rec: Record "Sales Line");
            var
                Currency: Record Currency;
            begin
                with rec do begin
                    //TOP210 DM 04/11/15 start
                    if "Temp Sales Order No." <> '' then begin
                        if ("Document Type" <> SalesHeader."Document Type") or ("Temp Sales Order No." <> SalesHeader."No.") then begin
                            SalesHeader.GET("Document Type", "Temp Sales Order No.");
                            if SalesHeader."Currency Code" = '' then
                                Currency.InitRoundingPrecision
                            else begin
                                SalesHeader.TESTFIELD("Currency Factor");
                                Currency.GET(SalesHeader."Currency Code");
                                Currency.TESTFIELD("Amount Rounding Precision");
                            end;
                        end;

                    end else begin
                        //TOP210 DM 04/11/15 end
                        if ("Document Type" <> SalesHeader."Document Type") or ("Document No." <> SalesHeader."No.") then begin
                            SalesHeader.GET("Document Type", "Document No.");
                            if SalesHeader."Currency Code" = '' then
                                Currency.InitRoundingPrecision
                            else begin
                                SalesHeader.TESTFIELD("Currency Factor");
                                Currency.GET(SalesHeader."Currency Code");
                                Currency.TESTFIELD("Amount Rounding Precision");
                            end;
                        end;

                    end; //TOP210 DM 04/11/15
                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnBeforeUpdateUnitPrice', '', false, false)]
            procedure Tb37_UpdateUnitPrice_PS(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer; var Handled: Boolean);
            var
                GotSalesPrice: Boolean;
                GotHotSheetPrice: Boolean;
                PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
                CustDivision: Record "Customer Division";
                Division: Record Division;
                UnitPricexRecValue: Decimal;
            begin
                //PSHUKLA
                if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then begin
                    Handled := true;
                    exit;
                end;
                if CalledByFieldNo = SalesLine.FIELDNO(Quantity) then begin
                    Handled := true;
                    SalesLine.VALIDATE("Unit Price");
                    exit;
                end;

                GetSalesHeader_Event(SalesLine);
                SalesLine.TESTFIELD("Qty. per Unit of Measure");
                //-->Std code open
                IF CalledByFieldNo = SalesLine.FIELDNO(Quantity) THEN BEGIN
                 IF (SalesLine."Shortcut Dimension 5 Code" <> 'E') AND (SalesLine."Shortcut Dimension 5 Code" <> 'P') THEN BEGIN //<TPZ2558> //<TPZ2641>
                 END ELSE BEGIN
                   EXIT;
                 END;
                END;
                //<--

                with SalesLine do begin

                    case Type of
                        Type::Item:
                            begin
                                "Pricing Logic" := "Pricing Logic"::"Sales Price";
                                UnitPricexRecValue := SalesLine."Unit Price";
                                SalesLine."Unit Price" := 0;
                                PriceCalcMgt.FindSalesLinePrice(SalesHeader, SalesLine, CalledByFieldNo);
                                if SalesLine."Unit Price" = 0 then begin
                                    SalesLine."Pricing Logic" := SalesLine."Pricing Logic"::" ";
                                    SalesLine."Unit Price" := UnitPricexRecValue;
                                end;
                            end;
                    end;
                end;

            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterUpdateUnitPrice', '', false, false)]
            procedure Tb37_UpdateUnitPrice_PS_1(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer);
            var
                GotSalesPrice: Boolean;
                GotHotSheetPrice: Boolean;
                PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
                CustDivision: Record "Customer Division";
                Division: Record Division;
            begin
                //PSHUKLA
                with SalesLine do begin
                    SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
                    //-->Std code open
                    IF CalledByFieldNo = SalesLine.FIELDNO(Quantity) THEN BEGIN
                     IF (SalesLine."Shortcut Dimension 5 Code" <> 'E') AND (SalesLine."Shortcut Dimension 5 Code" <> 'P') THEN BEGIN //<TPZ2558> //<TPZ2641>
                     END ELSE BEGIN
                       EXIT;
                     END;
                    END;
                    //<--

                    case Type of
                        Type::Item:
                            begin
                                if "Pricing Logic" = "Pricing Logic"::"Sales Price" then GotSalesPrice := true;
                                if "Pricing Logic" = "Pricing Logic"::"Hot Sheet" then GotHotSheetPrice := true;
                                //TOP230 KT ABCSI CRP 2 Fixes 05282015
                                if (not GotSalesPrice) and (not GotHotSheetPrice) then
                                    if "Recomm. Multiplier" = 0 then begin
                                        if CustDivision.GET(SalesHeader."Sell-to Customer No.", SalesHeader."Shortcut Dimension 5 Code") then begin
                                            if CustDivision.Multiplier <> 0 then begin
                                                "Line Discount %" := ROUND((1 - CustDivision.Multiplier) * 100, 0.00001); //TOP230 KT ABCSI Go Live Fixes 11092015
                                                "Recomm. Multiplier" := CustDivision.Multiplier;
                                                Multiplier := CustDivision.Multiplier;
                                                "Pricing Logic" := "Pricing Logic"::"Customer Base Multiplier"; //TOP230 KT ABCSI CRP 2 Fixes 06022015
                                            end;
                                        end;
                                    end;
                                //TOP230 KT ABCSI CRP 2 Fixes 05282015
                                if "Recomm. Multiplier" <> 0 then
                                    "Recomm. Unit Price" := ROUND("Unit Price" * "Recomm. Multiplier", 0.0001) //TOP230 KT ABCSI Go Live Fixes 11092015
                                else
                                    "Recomm. Unit Price" := "Unit Price";

                                if Multiplier <> 0 then
                                    "Actual Unit Price" := ROUND("Unit Price" * Multiplier, 0.0001)  //TOP230 KT ABCSI Go Live Fixes 11092015
                                else
                                    "Actual Unit Price" := ROUND("Unit Price", 0.0001);

                                if "Alt. UOM Code" <> '' then begin
                                    "Alt. UOM Actual Unit Price" := Tb37_CalcAltUOMUnitPrice(SalesLine, "Actual Unit Price");
                                    "Alt. UOM Recomm. Unit Price" := Tb37_CalcAltUOMUnitPrice(SalesLine, "Recomm. Unit Price");
                                end;
                            end;
                    end;
                    //TOP100A KT ABCSI Multipliers 02192015

                    // <TPZ875>
                    if ("Document Type" in ["Document Type"::Quote, "Document Type"::Order, "Document Type"::Invoice]) and
                       (Type = Type::Item) and
                       Division.GET(SalesHeader."Shortcut Dimension 5 Code") and
                       Division."Use Last Price as Recomm Price"
                    then begin
                        Tb37_GetLastSalesPrice(SalesLine);
                        "Line Discount %" := 0;
                        "Recomm. Multiplier" := 0;
                        Multiplier := 0;
                        "Unit Price" := "Last Unit Price";
                        "Recomm. Unit Price" := "Last Unit Price";
                        "Actual Unit Price" := "Last Unit Price";
                    end;
                    // </TPZ875>
                    VALIDATE("Unit Price"); //new
                end;

            end;

            procedure Tb37_SetStyleLastPriceDate(var Rec: Record "Sales Line"; var StyleTxtLastPriceDate: Text; CurrField: Integer);
            var
                LastYearDate: Date;
                ModifyDate: Date;
                SalesPrice: Record "Sales Price";
                SalesLineMultiplier: Record "Sales Line Discount";
                ItemMultiplier: Record Item;
                SalesPriceFound: Boolean;
                HotSheetPriceFound: Boolean;
                SalesLineMultiplierFound: Boolean;
                HotSheetPrice: Record "Hot Sheet Price";
                LastYearDateFound: Boolean;
                TextCH: Label 'There is no history for Item %1 , Customer %2 , the recommended price is outdated.';
            begin
                with Rec do begin
                    StyleTxtLastPriceDate := 'Standard';

                    LastYearDate := 0D;
                    LastYearDateFound := false;

                    ModifyDate := 0D;
                    SalesPriceFound := false;
                    HotSheetPriceFound := false;
                    SalesLineMultiplierFound := false;

                    if (Type = Type::Item) then begin

                        LastYearDate := CALCDATE('-1Y', WORKDATE);
                        if "Last Price Date" <> 0D then //BEGIN
                            if ("Last Price Date" < LastYearDate) then
                                LastYearDateFound := true
                            else
                                LastYearDateFound := false;
                         END ELSE
                          IF CurrField <> 0 THEN
                            MESSAGE(TextCH,"No.","Sell-to Customer No.");

                        if LastYearDateFound then begin
                            ModifyDate := CALCDATE('-6M', WORKDATE);
                            if "Pricing Logic" = "Pricing Logic"::"Sales Price" then begin
                                SalesPrice.RESET;
                                SalesPrice.SETCURRENTKEY("Modified Date");
                                SalesPrice.SETASCENDING("Modified Date", false);
                                SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::Customer);
                                SalesPrice.SETRANGE("Sales Code", "Sell-to Customer No.");
                                SalesPrice.SETRANGE("Item No.", "No.");
                                //SalesPrice.SETFILTER("Modified Date",'<%2',ModifyDate);
                                if SalesPrice.FINDFIRST then
                                    if SalesPrice."Modified Date" <> 0D then
                                        if SalesPrice."Modified Date" >= ModifyDate then
                                            SalesPriceFound := true;
                            end;
                            if ("Pricing Logic" = "Pricing Logic"::"Sales Line Multiplier(Cust.)") or ("Pricing Logic" = "Pricing Logic"::"Sales Line Multiplier(Cust. Mult. Grp.)") then begin
                                if SalesPriceFound = false then begin
                                    SalesLineMultiplier.RESET;
                                    SalesLineMultiplier.SETCURRENTKEY("Last Modified Date");
                                    SalesLineMultiplier.SETASCENDING("Last Modified Date", false);
                                    SalesLineMultiplier.SETRANGE("Sales Type", SalesLineMultiplier."Sales Type"::Customer);
                                    SalesLineMultiplier.SETRANGE("Sales Code", "Sell-to Customer No.");
                                    if ItemMultiplier.GET("No.") then
                                        SalesLineMultiplier.SETRANGE(Code, ItemMultiplier."Item Disc. Group");
                                    //SalesLineMultiplier.SETFILTER("Last Modified Date",'<%2',ModifyDate);
                                    if SalesLineMultiplier.FINDFIRST then
                                        if SalesLineMultiplier."Last Modified Date" <> 0D then
                                            if SalesLineMultiplier."Last Modified Date" >= ModifyDate then
                                                SalesLineMultiplierFound := true;
                                end;
                            end;
                            if ("Pricing Logic" = "Pricing Logic"::"Hot Sheet") then begin
                                if (SalesPriceFound = false) and (SalesLineMultiplierFound = false) then begin
                                    SalesLineMultiplier.RESET;
                                    SalesLineMultiplier.SETRANGE("Sales Type", SalesLineMultiplier."Sales Type"::Customer);
                                    SalesLineMultiplier.SETRANGE("Sales Code", "Sell-to Customer No.");
                                    if ItemMultiplier.GET("No.") then
                                        SalesLineMultiplier.SETRANGE(Code, ItemMultiplier."Item Disc. Group");
                                    SalesLineMultiplier.SETFILTER("Hot Sheet Code", '<>%1', '');
                                    if (SalesLineMultiplier.FINDFIRST) and (HotSheetPriceFound = false) then begin
                                        repeat
                                            HotSheetPrice.RESET;
                                            HotSheetPrice.SETRANGE(Code, SalesLineMultiplier."Hot Sheet Code");
                                            HotSheetPrice.SETRANGE("Item Disc. Group", SalesLineMultiplier.Code);
                                            HotSheetPrice.SETRANGE("Item No.", "No.");
                                            if HotSheetPrice.FINDFIRST then begin
                                                if HotSheetPrice."Last Modified Date" = 0D then
                                                    HotSheetPriceFound := false
                                                else begin
                                                    if HotSheetPrice."Last Modified Date" >= ModifyDate then
                                                        HotSheetPriceFound := true
                                                end;
                                            end;
                                        until SalesLineMultiplier.NEXT = 0;
                                    end;
                                end;
                            end;
                        end;
                        if (LastYearDateFound) and ((SalesPriceFound = false) and (SalesLineMultiplierFound = false) and (HotSheetPriceFound = false)) then
                            StyleTxtLastPriceDate := 'Ambiguous';
                    end;
                end;

            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'No.', false, false)]
            procedure Tb37_ItemNo_OnValidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            var
                Item: Record Item;
                ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                BlockedItemAttributeValue: Label 'Item Attribute Value "%1", associated with item"%2" is blocked. \This Item is blocked from being sold in %1 location';
                SalesHeader: Record "Sales Header";
            begin
                //>>TPZ2837
                if Rec.Type <> Rec.Type::Item then
                    exit;
                if Item.GET(Rec."No.") then begin
                    ItemAttributeValueMapping.RESET;
                    ItemAttributeValueMapping.SETFILTER("Table ID", '27');
                    ItemAttributeValueMapping.SETRANGE("No.", Rec."No.");
                    ItemAttributeValueMapping.SETFILTER("Item Attribute ID", '1');
                    ItemAttributeValueMapping.SETFILTER("Item Attribute Value ID", '817'); //CA
                    if ItemAttributeValueMapping.FINDFIRST then
                        if SalesHeader.GET(SalesHeader."Document Type"::Order, Rec."Document No.") then
                            //IF (SalesHeader."Bill-to County" = 'CA' ) OR (SalesHeader."Sell-to County" = 'CA') THEN
                            if (SalesHeader."Ship-to County" = 'CA') then
                                //>>TPZ2891
                                //ERROR(BlockedItemAttributeValue,'CA',Item."No.");
                                MESSAGE(BlockedItemAttributeValue, 'CA', Item."No.");
                    //<<TPZ2891
                end;
                //<<TPZ2837
            end;

            local procedure AvgCostPerLocation(var SalesLinePara: Record "Sales Line");
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                TotalCostPerUnit: Decimal;
                ItemLoc: Record Item;
                TotalRemainingQty: Decimal;
                NoOfEntry: Integer;
            begin
                if (SalesLinePara.Type = SalesLinePara.Type::Item) then begin //AND (Rec."Location Code" <> '') THEN BEGIN
                    TotalCostPerUnit := 0;
                    TotalRemainingQty := 0;
                    NoOfEntry := 0;
                    ItemLoc.GET(SalesLinePara."No.");
                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
                    ItemLedgerEntry.SETRANGE("Item No.", SalesLinePara."No.");
                    ItemLedgerEntry.SETRANGE(Open, true);
                    ItemLedgerEntry.SETFILTER("Location Code", '<>%1&<>%2', 'ONWATER', 'OWTRANSIT');
                    if ItemLedgerEntry.FINDFIRST then
                        repeat
                            ItemLedgerEntry.CALCFIELDS("Cost per Unit", "Cost Amount (Actual)", "Cost Amount (Expected)");
                            if ItemLedgerEntry.Quantity > 0 then
                                TotalCostPerUnit += (((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)")
                                                    / ItemLedgerEntry.Quantity) * ItemLedgerEntry."Remaining Quantity")
                            else
                                TotalCostPerUnit += ((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)")
                                                     * ItemLedgerEntry."Remaining Quantity");
                            TotalRemainingQty += ItemLedgerEntry."Remaining Quantity";
                        until ItemLedgerEntry.NEXT = 0;
                    if TotalRemainingQty = 0 then
                        TotalRemainingQty := 1;
                    SalesLinePara."Average Unit Cost" := ROUND(TotalCostPerUnit / TotalRemainingQty, 0.0001, '=');
                    //IF SalesLinePara."Average Unit Cost" = 0 THEN  //If cost zero then don't need to get from item card
                    //SalesLinePara."Average Unit Cost" := ROUND(SalesLinePara."Unit Cost (LCY)",0.0001,'=');
                end;
            end;

            [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'Quote Line No.', false, false)]
            procedure "UpdateActualPriceFromQuoteLineNo."(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer);
            var
                SLLoc: Record "Sales Line";
            begin
                with Rec do begin
                    if "Quote Line No." <> 0 then
                        TESTFIELD("Quote No.");
                    if SLLoc.GET(SLLoc."Document Type"::Quote, "Quote No.", "Quote Line No.") then begin
                        if "No." <> SLLoc."No." then
                            ERROR(Text0000, SLLoc."No.", "No.");
                        "Unit Price" := SLLoc."Unit Price";
                        Multiplier := SLLoc.Multiplier;
                        "Recomm. Unit Price" := SLLoc."Recomm. Unit Price";
                        "Actual Unit Price" := SLLoc."Actual Unit Price";
                        "Alt. UOM Recomm. Unit Price" := SLLoc."Alt. UOM Recomm. Unit Price";
                        "Alt. UOM Actual Unit Price" := SLLoc."Alt. UOM Actual Unit Price";
                        "Recomm. Multiplier" := SLLoc."Recomm. Multiplier";
                        "Alt. UOM Unit Price" := SLLoc."Alt. UOM Unit Price";
                        "Old Actual Unit Price" := SLLoc."Old Actual Unit Price";
                        "New Actual Unit Price" := SLLoc."New Actual Unit Price";
                        "Requested Unit Price" := SLLoc."Requested Unit Price";
                        "Line Discount %" := SLLoc."Line Discount %";
                        VALIDATE("Unit Price");
                        MODIFY;
                    end;
                end;
            end;

            procedure Pg516_SelltoCustName(var SelltoCustNo: Code[20]): Text;
            var
                Customer_Local: Record Customer;
            begin
                //001 TPZ2994
                Customer_Local.RESET;
                if Customer_Local.GET(SelltoCustNo) then
                    exit(Customer_Local.Name);

                exit('');
                //001 TPZ2994
            end;

            procedure GetAvgCostPerUnitPerLoc(var SalesLinePara: Record "Sales Line");
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                TotalCostPerUnit: Decimal;
                ItemLoc: Record Item;
                TotalRemainingQty: Decimal;
                NoOfEntry: Integer;
                AvgCostPerUnit: Decimal;
            begin
                ////TPZ2993 PSHUKLA new functionality for Avg Unit cost per location
                TotalCostPerUnit := 0;
                TotalRemainingQty := 0;
                NoOfEntry := 0;
                AvgCostPerUnit := 0;
                if ItemLoc.GET(SalesLinePara."No.") then begin
                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
                    ItemLedgerEntry.SETRANGE("Item No.", ItemLoc."No.");
                    ItemLedgerEntry.SETRANGE(Open, true);
                    if SalesLinePara."Location Code" <> '' then
                        ItemLedgerEntry.SETRANGE("Location Code", SalesLinePara."Location Code")
                    else
                        ItemLedgerEntry.SETFILTER("Location Code", '<>%1&<>%2', 'ONWATER', 'OWTRANSIT');
                    if ItemLedgerEntry.FINDFIRST then
                        repeat
                            ItemLedgerEntry.CALCFIELDS("Cost per Unit", "Cost Amount (Actual)", "Cost Amount (Expected)");
                            if ItemLedgerEntry.Quantity > 0 then
                                TotalCostPerUnit += (((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)")
                                                    / ItemLedgerEntry.Quantity) * ItemLedgerEntry."Remaining Quantity")
                            else
                                TotalCostPerUnit += ((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)")
                                                     * ItemLedgerEntry."Remaining Quantity");
                            TotalRemainingQty += ItemLedgerEntry."Remaining Quantity";
                        until ItemLedgerEntry.NEXT = 0;

                    if TotalRemainingQty = 0 then
                        TotalRemainingQty := 1;
                    SalesLinePara."Average Unit Cost Per Loc" := ROUND(TotalCostPerUnit / TotalRemainingQty, 0.0001, '=');
                end;
            end;

            procedure Tb37_GetLastSalesPrice_Quote(var ToSalesLine: Record "Sales Line"): Decimal;
            var
                LastSalesPrice: Record "Last Sales Price";
            begin
                //<TPZ2995>
                with ToSalesLine do begin
                    if ToSalesLine.Type <> ToSalesLine.Type::Item then
                        exit;
                    LastSalesPrice.RESET;
                    LastSalesPrice.ASCENDING;
                    LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
                    LastSalesPrice.SETRANGE("Sell-to Customer No.", ToSalesLine."Sell-to Customer No.");
                    LastSalesPrice.SETRANGE("Item No.", ToSalesLine."No.");
                    LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::Quote);
                    if LastSalesPrice.FINDLAST then
                        exit(LastSalesPrice."Last Unit Price");

                    exit(0);
                end;
                //</TPZ2995>
            end;

            procedure Tb37_GetLastSalesPriceDate_Quote(var ToSalesLine: Record "Sales Line"): Date;
            var
                LastSalesPrice: Record "Last Sales Price";
            begin
                //<TPZ2995>
                with ToSalesLine do begin
                    if ToSalesLine.Type <> ToSalesLine.Type::Item then
                        exit;
                    LastSalesPrice.RESET;
                    LastSalesPrice.ASCENDING;
                    LastSalesPrice.SETCURRENTKEY("Sell-to Customer No.", "Item No.", "Document Date");
                    LastSalesPrice.SETRANGE("Sell-to Customer No.", ToSalesLine."Sell-to Customer No.");
                    LastSalesPrice.SETRANGE("Item No.", ToSalesLine."No.");
                    LastSalesPrice.SETRANGE("Document Type", LastSalesPrice."Document Type"::Quote);
                    if LastSalesPrice.FINDLAST then
                        exit(LastSalesPrice."Last Price Date");

                    exit(0D);
                end;
                //</TPZ2995>
            end;

            procedure Pg516_SalesHeaderCustPONo(var SL: Record "Sales Line"): Text;
            var
                SH_Local: Record "Sales Header";
            begin
                //<TPZ3016>
                SH_Local.RESET;
                if SH_Local.GET(SL."Document Type", SL."Document No.") then
                    exit(SH_Local."External Document No.");

                exit('');

                //</TPZ3016>
            end;

            procedure Pg516_SalesHeaderStatus(var SL: Record "Sales Line"): Text;
            var
                SH_Local: Record "Sales Header";
            begin
                //<TPZ3016>
                SH_Local.RESET;
                if SH_Local.GET(SL."Document Type", SL."Document No.") then
                    exit(FORMAT(SH_Local.Status));

                exit('');
            end;

            local procedure ReplacementCost(var SalesLinePara: Record "Sales Line");
            var
                ItemLoc: Record Item;
            begin
                //TPZ3125
                if (SalesLinePara.Type = SalesLinePara.Type::Item) then begin
                    if ItemLoc.GET(SalesLinePara."No.") and (ItemLoc."Replacement Cost" <> 0) then
                        SalesLinePara."Replacement Cost" := ItemLoc."Replacement Cost"
                    else
                        SalesLinePara."Replacement Cost" := SalesLinePara."Average Unit Cost";
                end;
            end;
        */
}

