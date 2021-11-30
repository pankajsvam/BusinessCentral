codeunit 50148 ReleaseSalesDocument
{
    trigger OnRun();
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', true, true)]
    local procedure CU414_OnRun(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        Cust: Record Customer;
        tmpSalesLine: Record "Sales Line";
        RetrunReason: Record "Return Reason";
    begin
        //error('Pankaj');
        //<TPZ1666>
        cust.GET(SalesHeader."Sell-to Customer No.");
        cust.CheckBlockedCustOnDocs(cust, SalesHeader."Document Type", FALSE, FALSE);
        //<TPZ1666>
        //<TPZ118>  <TPZ1692>
        tmpSalesLine.RESET();
        tmpSalesLine.SETRANGE("Document Type", SalesHeader."Document Type"::"Return Order");
        tmpSalesLine.SETRANGE("Document No.", SalesHeader."No.");
        tmpSalesLine.SETRANGE(Type, tmpSalesLine.Type::Item);
        tmpSalesLine.SETFILTER(Quantity, '<>0');
        IF tmpSalesLine.FIND('-') THEN
            REPEAT
                RetrunReason.GET(tmpSalesLine."Return Reason Code");
                IF RetrunReason.Type = RetrunReason.Type::Quality THEN
                    tmpSalesLine.TESTFIELD("QA Sub Reason Code");

            UNTIL tmpSalesLine.NEXT = 0;
        //</TPZ118>
        //</TPZ1692>

        //<TPZ1636>
        tmpSalesLine.RESET();
        tmpSalesLine.SETRANGE("Document Type", SalesHeader."Document Type"::"Return Order");
        tmpSalesLine.SETRANGE("Document No.", SalesHeader."No.");
        tmpSalesLine.SETRANGE(Type, tmpSalesLine.Type::Item);
        tmpSalesLine.SETRANGE("Appl.-from Item Entry", 0);
        tmpSalesLine.SETFILTER(Quantity, '<>0');
        IF tmpSalesLine.FIND('-') THEN BEGIN
            REPEAT
                RetrunReason.GET(tmpSalesLine."Return Reason Code");
                IF (RetrunReason.Type <> RetrunReason.Type::"Annual Return") THEN
                    ERROR(TextApplError, tmpSalesLine."Document No.", tmpSalesLine."Line No.");
            UNTIL tmpSalesLine.NEXT = 0;
        END;
        //</TPZ1636>

        //<TPZ1454>
        IF (SalesHeader."Shipping Payment Type" = SalesHeader."Shipping Payment Type"::"Third Party")
         AND (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) THEN
            SalesHeader.TESTFIELD(SalesHeader."Third Party Ship. Account No.");
        //<TPZ1454>

        // <TPZ930>
        CU414_ValidateSalesLines(SalesHeader);
        // </TPZ930>

    end;

    procedure CU414_ValidateSalesLines(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Order THEN
            EXIT;

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF SalesLine.FINDSET THEN
            REPEAT
                IF (SalesLine.Type = SalesLine.Type::" ") AND (SalesLine."No." = '') THEN
                    SalesLine.TESTFIELD(Description);
                IF (SalesLine.Type = SalesLine.Type::Item) AND
                   (SalesLine."No." <> '') AND
                   (SalesLine.Quantity <> 0) AND
                    NOT SalesLine.Sample AND
                    NOT SalesLine.Promo //<TPZ2368> 
                THEN BEGIN
                    SalesLine.TESTFIELD("Actual Unit Price");
                    SalesLine.TESTFIELD(Description); //<TPZ1765>
                END;
            UNTIL SalesLine.NEXT = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeModifySalesDoc', '', true, true)]
    local procedure CU414_OnRun_1(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; Var IsHandled: Boolean)
    var
        Cust: Record Customer;
        tmpSalesLine: Record "Sales Line";
        RetrunReason: Record "Return Reason";
        tmpLocation: Record Location;
        ShippingAgents: Record "Shipping Agent";
        SalesSetup: Record "Sales & Receivables Setup";
        CalendarMgmt: Codeunit "Calendar Management";
        WarehouseRequest: Record "Warehouse Request";
        LocationBackup: Record Location;
        Division: Record Division;
        SalesSplitOrder: Codeunit "Sales-Split Order";
        PaymentTerms: Record "Payment Terms";
        UserSetup: Record "User Setup";
        CustomCalendarChange: Array[2] of Record "Customized Calendar Change";
        Text51095: TextConst ENU = 'Payment Term %1 cannot be combined with %2.';
    begin
        //<TPZ1530>

        SalesSetup.GET;
        //<TPZ3377>
        /*
        IF Status = Status::"Pending Approval" THEN BEGIN
               "Shipment Date" := WORKDATE;
               MODIFY();
           END;
         //VAH
        //</TPZ3377>
        {TPZ3322 Code Commented, shipment date will remain same as they enter on SO
         IF NOT RunFromEship  THEN BEGIN
          tmpLocation.GET("Location Code");
          //IF ("Document Type" = "Document Type"::Order) AND (tmpLocation."Shipping Location") AND (("Shipment Date")<WORKDATE) THEN BEGIN //TPZ1894 EB
          IF ("Document Type" = "Document Type"::Order) AND (tmpLocation."Shipping Location" OR tmpLocation."Auto Pick") AND (("Shipment Date")<WORKDATE) THEN BEGIN //TPZ1894 EB TPZ3271
              "Shipment Date" := WORKDATE;
              MODIFY();
          END;
        END;
        //</TPZ1530>
        *///TPZ3322
          //<TPZ1953>
          //IF ("Delivery Date"<=WORKDATE) AND ("Delivery Date"<>0D)  THEN BEGIN //<TPZ2257>
        tmpLocation.GET(SalesHeader."Location Code");
        ShippingAgents.GET(SalesHeader."Shipping Agent Code");
        UserSetup.GET(USERID);//<TPZ3269>
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND
        (tmpLocation."Shipping Location") AND (ShippingAgents.Type = ShippingAgents.Type::"Local")
           AND (NOT UserSetup."Warehouse Employee") THEN BEGIN  //EB  TMW //<TPZ3269>
            SalesHeader."Delivery Date" := CalendarMgmt.CalcDateBOC('+1WD', SalesHeader."Shipment Date", CustomCalendarChange, FALSE);
            SalesHeader.MODIFY;
        END;
        //END;
        //</TPZ1953>

        // <TPZ573>
        //Pankaj need to create new CU
        IF SalesSetup."Calc. Free Freight" THEN
            CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Free Freight", SalesHeader);
        // </TPZ573>


        //TOP090 KT ABCSI 01072015

        IF SalesSetup."Ext. Doc. No. Mandatory" AND
           ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order")) //<TPZ1929)
        THEN
            SalesHeader.TESTFIELD(SalesHeader."External Document No.");
        //TOP090 KT ABCSI 01072015

        //<TPZ1576>
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Quote) AND (SalesHeader."Shortcut Dimension 5 Code" = 'L') THEN
            SalesHeader.TESTFIELD(SalesHeader."Job Name");
        //</TPZ1576>

        // <TPZ426>

        IF SalesSetup."Validate Ext. Doc. No. Format" AND
           (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)
        THEN
            CU414_ValidateExtDocNoFormat(SalesHeader);

        // <TPZ1118>
        IF Cust.GET(SalesHeader."Sell-to Customer No.") AND
           Cust."Ship-to Code Mandatory" AND
           ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR
            (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice))
        // <TPZ1118>
        THEN BEGIN    //<TPZ1424
            SalesHeader.TESTFIELD(SalesHeader."Ship-to Code");
            SalesHeader.TESTFIELD(SalesHeader."Ship-to Name");
            SalesHeader.TESTFIELD(SalesHeader."Ship-to Address");

            //<TPZ1424>
            IF (SalesHeader."Shortcut Dimension 5 Code" <> 'I') AND
              ((SalesHeader."Ship-to Country/Region Code" = 'US') OR
              (SalesHeader."Ship-to Country/Region Code" = ''))
            THEN BEGIN
                SalesHeader.TESTFIELD("Ship-to City");
                SalesHeader.TESTFIELD(SalesHeader."Ship-to County");
                SalesHeader.TESTFIELD(SalesHeader."Ship-to Post Code");
            END;
        END;
        // </TPZ426>

        //<TPZ1424>
        IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR
            (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice))
        THEN BEGIN
            SalesHeader.TESTFIELD("Shipping Agent Code");
        END;
        //</TPZ1424>

        // <TPZ159>
        IF SalesSetup."Dupl. Whse. Rel. No. Warning" AND
           (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)
        THEN
            CU414_ValidateWhseReleaseNo(SalesHeader);
        // </TPZ159>

        // <TPZ1145>
        IF Division.GET(SalesHeader."Shortcut Dimension 5 Code") THEN BEGIN
            IF Division."OSR Code Mandatory" THEN
                SalesHeader.TESTFIELD("Salesperson Code");

            IF Division."Mfr. Rep. Code Mandatory" THEN
                SalesHeader.TESTFIELD("Mfr. Rep. Code");
        END;
        // </TPZ1145>


        // <TPZ844>
        IF SalesSetup."One Location per Order" AND
           (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)
        THEN
            CU414_ValidateOneLocation(SalesHeader);
        // </TPZ844>


        //2016-03-14 TPZ1256 EBAGIM
        IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::"Credit Memo",
        SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Return Order"] THEN
            CU414_ValidateOneDivision(SalesHeader);

        //2016-03-14 TPZ1256 EBAGIM

        //<TPZ2782>
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND (SalesHeader.Status = SalesHeader.Status::Open) THEN BEGIN
            LocationBackup.RESET;
            //IF LocationBackup.GET(SalesHeader."Location Code") AND (LocationBackup."Backup Location Code" <> '') THEN
            //SalesSplitOrder.CreateSplitOrder(SalesHeader); dekhna hai
        END;
        //<TPZ2782>

        // <TPZ884>
        IF PaymentTerms.GET(SalesHeader."Payment Terms Code") AND
           PaymentTerms."Do Not Allow Blind Shipment" AND
           SalesHeader."Blind Shipment"
        THEN
            ERROR(Text51095, PaymentTerms.Code, SalesHeader.FIELDCAPTION("Blind Shipment"));

        IF PaymentTerms.GET(SalesHeader."Payment Terms Code") AND
           PaymentTerms."Do Not Allow Double Bl. Shpt." AND
           SalesHeader."Double Blind Shipment"

        THEN
            ERROR(Text51095, PaymentTerms.Code, SalesHeader.FIELDCAPTION(SalesHeader."Double Blind Shipment"));
        // </TPZ884>

    END;

    procedure CU414_ValidateExtDocNoFormat(SalesHeader: Record "Sales Header")
    var
        Cust: Record Customer;
        ShipToAddr: Record "Ship-to Address";
        Text51096: TextConst ENU = 'does not match %1 %2';
    begin
        // <TPZ426>

        IF SalesHeader."Ship-to Code" <> '' THEN BEGIN
            ShipToAddr.GET(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code");
            IF ShipToAddr."External Document No. Mask" <> '' THEN
                IF NOT CU414_ValidateExtDocNoUsingMask(SalesHeader."External Document No.", ShipToAddr."External Document No. Mask") THEN
                    SalesHeader.FIELDERROR(
                      SalesHeader."External Document No.",
                      STRSUBSTNO(
                        Text51096,
                        ShipToAddr.FIELDCAPTION("External Document No. Mask"),
                        ShipToAddr."External Document No. Mask"));
        END ELSE BEGIN
            Cust.GET(SalesHeader."Sell-to Customer No.");
            IF Cust."External Document No. Mask" <> '' THEN
                IF NOT CU414_ValidateExtDocNoUsingMask(SalesHeader."External Document No.", Cust."External Document No. Mask") THEN
                    SalesHeader.FIELDERROR(
                      SalesHeader."External Document No.",
                      STRSUBSTNO(
                        Text51096,
                        Cust.FIELDCAPTION("External Document No. Mask"),
                        ShipToAddr."External Document No. Mask"));
        END;

        // </TPZ426>
    end;

    procedure CU414_ValidateExtDocNoUsingMask(ExternalDocumentNo: Code[35]; ExternalDocumentNoMask: code[35])
    ReturnValue: Boolean;
    var
        Index: Integer;
    begin
        // <TPZ426>
        FOR Index := 1 TO STRLEN(ExternalDocumentNoMask) DO
            IF (ExternalDocumentNoMask[Index] = '0') THEN BEGIN
                IF NOT (ExternalDocumentNo[Index] IN ['0' .. '9']) THEN
                    EXIT(FALSE);
            END ELSE
                IF ExternalDocumentNo[Index] <> ExternalDocumentNoMask[Index] THEN
                    EXIT(FALSE);
        EXIT(TRUE);
        // </TPZ426>
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', true, true)]
    local procedure CU414_OnRun_2(VAR SalesHeader: Record "Sales Header"; PreviewMode: Boolean; LinesWereModified: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ArchiveManagement: Codeunit ArchiveManagement;
        WhseRqst: Record "Warehouse Request";
        Salesperson: Record "Salesperson/Purchaser";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        tmpSalesLine: Record "Sales Line";
        RetrunReason: Record "Return Reason";
        //EMailSetup:	Record	E-Mail Setup	
        //SalesReturnEmail:	Report	"Sales Return E-Mail"	
        WarehouseRequest: Record "Warehouse Request";
        //SalesOrderEMail:	Report	"Sales E-Mail	";
        Location: Record Location;
    begin


        //WITH SalesHeader DO BEGIN
        //TOP170 KT ABCSI Sales Order Updates 04012015
        SalesSetup.GET;
        IF SalesSetup."Archive Orders" or (SalesSetup."Archive Quotes" <> SalesSetup."Archive Quotes"::Never) THEN
            ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
        //TOP170 KT ABCSI Sales Order Updates 04012015


        //TOP150 - KT ABCSI Sales Order Margin Review 04032015 Start

        //IF (NOT RunFromEship) AND (CreateWhseShpt) THEN BEGIN //Pankaj commented
        IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order]) THEN BEGIN
            WhseRqst.SETRANGE(Type, WhseRqst.Type::Outbound);
            WhseRqst.SETRANGE("Source Type", DATABASE::"Sales Line");
            WhseRqst.SETRANGE("Source Subtype", SalesHeader."Document Type");
            WhseRqst.SETRANGE("Source No.", SalesHeader."No.");
            WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
            IF (NOT WhseRqst.ISEMPTY) AND (NOT CU414_CheckifWhseShptExists(SalesHeader)) THEN
                GetSourceDocOutbound.CreateFromSalesOrder(SalesHeader);
        END;
        //END;
        //TOP150 - KT ABCSI Sales Order Margin Review 04032015 End
        //<TPZ1576>
        /* Pankaj Code commented due lanham table
        SalesHeader.CALCFIELDS(Amount);
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Quote) AND (SalesHeader."Shortcut Dimension 5 Code" = 'L') AND (SalesHeader."E-Mail Confirmation Handled" = FALSE) THEN BEGIN
            IF Salesperson.GET(SalesHeader."RSM Code") AND (Salesperson."Send Quote Confirmation") AND (Amount >= SalesSetup."Min Quote Ntf Amount") THEN BEGIN
                EmailListEntry.INIT();
                EmailListEntry."Table ID" := 36;
                EmailListEntry.Type := "Document Type";
                EmailListEntry.Code := "No.";
                EmailListEntry."Entry No." := 100000;

                EmailListEntry."E-Mail" := Salesperson."E-Mail";
                EmailListEntry."Sales Quote Conf. E-Mail" := EmailListEntry."Sales Quote Conf. E-Mail"::"To";
                EmailListEntry.INSERT();
                SalesOrderEMail.InitializeRequest("Document Type", "No.", FALSE);
                SalesOrderEMail.USEREQUESTPAGE(FALSE);
                SalesOrderEMail.RUNMODAL;

            END;
            //>>002 TPZ3105
            IF Salesperson.GET("Salesperson Code") AND (Salesperson."Send Quote Confirmation") AND (Amount >= SalesSetup."Min Quote Ntf Amount") THEN BEGIN
                EmailListEntry.INIT();
                EmailListEntry."Table ID" := 36;
                EmailListEntry.Type := "Document Type";
                EmailListEntry.Code := "No.";
                EmailListEntry."Entry No." := 100000;

                EmailListEntry."E-Mail" := Salesperson."E-Mail";
                EmailListEntry."Sales Quote Conf. E-Mail" := EmailListEntry."Sales Quote Conf. E-Mail"::"To";
                EmailListEntry.INSERT();
                SalesOrderEMail.InitializeRequest("Document Type", "No.", FALSE);
                SalesOrderEMail.USEREQUESTPAGE(FALSE);
                SalesOrderEMail.RUNMODAL;

            END;
        END;
        
        //<<002 TPZ3105
        //</TPZ1576>

        //<TPZ118>

        IF ("Document Type" = "Document Type"::"Return Order") AND ("E-Mail Confirmation Handled" = FALSE) THEN BEGIN
            tmpSalesLine.RESET();
            tmpSalesLine.SETRANGE("Document Type", "Document Type"::"Return Order");
            tmpSalesLine.SETRANGE("Document No.", "No.");
            tmpSalesLine.SETRANGE(Type, tmpSalesLine.Type::Item);
            tmpSalesLine.SETFILTER(Quantity, '<>0');
            IF tmpSalesLine.FIND('-') THEN BEGIN
                RetrunReason.GET(tmpSalesLine."Return Reason Code");
                IF RetrunReason.Type = RetrunReason.Type::Quality THEN BEGIN
                    EmailListEntry.INIT();
                    EmailListEntry."Entry No." := 100000;
                    EmailListEntry."Table ID" := 36;
                    EmailListEntry.Type := "Document Type";
                    EmailListEntry.Code := "No.";
                    EMailSetup.GET(' ');
                    EmailListEntry."E-Mail" := EMailSetup."Qualty Return Conf. E-Mail";
                    EmailListEntry."Sales Ret. Order Conf. E-Mail" := EmailListEntry."Sales Ret. Order Conf. E-Mail"::"To";
                    EmailListEntry.INSERT();
                    SalesReturnEmail.InitializeRequest("Document Type", "No.", FALSE);

                    SalesReturnEmail.USEREQUESTPAGE(FALSE);
                    SalesReturnEmail.RUNMODAL;

                END;

            END;
        END;
        //</TPZ118>
Pankaj */
        //TMEI BEG 070215 - WMS Mod
        CU414_UpdateOutboundWhseRequest(SalesHeader);
        //TMEI END 070215

        //<TPZ1942>
        CU414_CheckSalesLineQtyRounding(SalesHeader);
        //</TPZ1942>
        //<TPZ2673>
        WarehouseRequest.RESET;
        WarehouseRequest.SETRANGE("Source Type", 37);
        WarehouseRequest.SETRANGE("Source Document", WarehouseRequest."Source Document"::"Sales Order");
        WarehouseRequest.SETRANGE("Source No.", SalesHeader."No.");
        //WarehouseRequest.SETRANGE("Activity Status",WarehouseRequest."Activity Status"::" ");//EB
        IF WarehouseRequest.FINDFIRST THEN
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN BEGIN
                IF Location.GET(SalesHeader."Location Code") THEN BEGIN
                    IF Location."Auto Pick" THEN BEGIN
                        CU414_CreateJobQueueforAutoPick(SalesHeader);
                        //<TPZ2701>
                        //IF CU414_PickEmailExists(SalesHeader) THEN //VAH bug fix
                        //CU414_CreateJobQueueForSendingPick(SalesHeader);
                        //</TPZ2701>
                    END;
                END;
            END;
        //</TPZ2673>

    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforePerformManualRelease', '', true, true)]
    local procedure CU414_PerformManualCheckAndRelease(VAR SalesHeader: Record "Sales Header";
    PreviewMode: Boolean; IsHandled: Boolean)
    var
        Cust: Record Customer;
        Rec_SalesLine: Record "Sales Line";
        Item: Record item;
        SalesLine: Record "Sales Line";
        SalesLine1: Record "Sales Line";
        tmpLocation: Record Location;
        ShippingAgents: Record "Shipping Agent";
        CalendarMgmt: Codeunit "Calendar Management";
        ItemTypeCheck: Record item;
        RoundedUpQty: Decimal;
        UserSetup: Record "User Setup";
        CustomCalendarChange: Array[2] of Record "Customized Calendar Change";
        Table37EventSubscribers: Codeunit Table37EventSubscribers;
    begin
        //WITH SalesHeader DO BEGIN
        //<TPZ3183>
        CU414_DuplicateSanaPOCheck(SalesHeader);
        //</TPZ3183>
        //<TPZ2247>
        Cust.GET(SalesHeader."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, SalesHeader."Document Type", FALSE, FALSE);
        //</TPZ2247>
        /*pankaj dekhna//>>TPZ2893
        Rec_SalesLine.RESET;
        Rec_SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        Rec_SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF Rec_SalesLine.FINDSET THEN
            REPEAT
                IF (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Quote, SalesHeader."Document Type"::Order]) AND
                  (Rec_SalesLine.Type = Rec_SalesLine.Type::Item) AND
                  (Rec_SalesLine.Quantity <> 0) AND
                  Item.GET(Rec_SalesLine."No.") AND
                  (Item."Sales Order Multiple" <> 0) AND
                  (Rec_SalesLine."Outstanding Quantity" <> 0)
                AND (NOT Item."Override Sales Order Multiple")  //TPZ2899
               THEN BEGIN
                    IF Rec_SalesLine.Quantity MOD Item."Sales Order Multiple" <> 0 THEN BEGIN
                        ERROR(TextRNDERROR, Item."Sales Order Multiple", Rec_SalesLine."Line No.", Item."No.");
                    END;
                END;
            UNTIL Rec_SalesLine.NEXT = 0;
        //<<TPZ2893
        */
        //TOP010E KT ABCSI Additional Stock Status 07282015
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Quote) AND (SalesHeader."Lock Price") THEN BEGIN
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            IF SalesLine.FINDSET THEN
                REPEAT
                    IF SalesLine."Actual Unit Price" <> 0 THEN;
                //SalesLine.UpdateLastSalesPrice(SalesLine);
                //Table37EventSubscribers.Tb37_UpdateLastSalesPrice(SalesLine); //dekhna hai
                UNTIL SalesLine.NEXT = 0;
        END;
        //TOP010E KT ABCSI Additional Stock Status 07282015

        //<TPZ2482>
        IF (salesheader."Document Type" = salesheader."Document Type"::Order) THEN BEGIN
            SalesLine1.SETRANGE("Document Type", salesheader."Document Type");
            SalesLine1.SETRANGE("Document No.", salesheader."No.");
            IF SalesLine1.FINDSET THEN
                REPEAT
                    ItemTypeCheck.RESET;
                    IF ItemTypeCheck.GET(SalesLine1."No.") THEN BEGIN
                        IF ItemTypeCheck.Type = ItemTypeCheck.Type::Service THEN BEGIN
                            SalesLine1.VALIDATE("Qty. to Ship", SalesLine1.Quantity);
                            SalesLine1.MODIFY(TRUE);
                        END;
                    END;
                UNTIL SalesLine1.NEXT = 0;
        END;
        //</TPZ2482>

        //<TPZ1927>  <TPZ1970>
        ShippingAgents.GET(SalesHeader."Shipping Agent Code");
        UserSetup.GET(USERID);//<TPZ3269>
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND (tmpLocation."Shipping Location") AND (ShippingAgents.Type = ShippingAgents.Type::"Local")
           AND (NOT UserSetup."Warehouse Employee") THEN BEGIN  //EB  TMW //<TPZ3269>
            //SalesHeader."Delivery Date" := CalendarMgmt.CalcDateBOC('+1WD', SalesHeader."Shipment Date", 0, '1', '', 0, '', '', FALSE);
            SalesHeader."Delivery Date" := CalendarMgmt.CalcDateBOC('+1WD', SalesHeader."Shipment Date", CustomCalendarChange, FALSE);
            SalesHeader.MODIFY;
        END;

        CU414_ItemShipRestriction(SalesHeader);//<TPZ3151>
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforePerformManualRelease', '', true, true)]
    local procedure CU414_PerformManualCheckAndRelease_1(VAR SalesHeader: Record "Sales Header"; PreviewMode: Boolean; IsHandled: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        Division: Record Division;
        PaymentTerms: Record "Payment Terms";
        Text51095: TextConst ENU = 'Payment Term %1 cannot be combined with %2.';
    begin
        //WITH SalesHeader DO BEGIN
        //TOP090 KT ABCSI - Customer PO Mandatory 06042015
        SalesSetup.GET;
        IF SalesSetup."Ext. Doc. No. Mandatory" AND
           ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order")) //<VSO1929)
        THEN
            SalesHeader.TESTFIELD("External Document No.");
        //TOP090 KT ABCSI - Customer PO Mandatory 06042015

        // <TPZ426>
        IF SalesSetup."Validate Ext. Doc. No. Format" AND
          (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)
        THEN
            CU414_ValidateExtDocNoFormat(SalesHeader);

        // <TPZ1118>
        IF Cust.GET(SalesHeader."Sell-to Customer No.") AND
           Cust."Ship-to Code Mandatory" AND
           ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR
            (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice))
        // <TPZ1118>
        THEN BEGIN    //<TPZ1424
            SalesHeader.TESTFIELD(SalesHeader."Ship-to Code");
            SalesHeader.TESTFIELD(SalesHeader."Ship-to Name");
            SalesHeader.TESTFIELD(SalesHeader."Ship-to Address");

            //<TPZ1424>
            IF (SalesHeader."Shortcut Dimension 5 Code" <> 'I') AND
               ((SalesHeader."Ship-to Country/Region Code" = 'US') OR
               (SalesHeader."Ship-to Country/Region Code" = ''))
             THEN BEGIN
                SalesHeader.TESTFIELD(SalesHeader."Ship-to City");
                SalesHeader.TESTFIELD(SalesHeader."Ship-to County");
                SalesHeader.TESTFIELD(SalesHeader."Ship-to Post Code");
            END;
        END;
        // </TPZ426>

        //<TPZ1424>
        IF ((SalesHeader."Document Type" = SalesHeader."Document Type"::Order) OR
            (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice))
        THEN BEGIN
            SalesHeader.TESTFIELD("Shipping Agent Code");
        END;
        //</TPZ1424>

        // <TPZ159>
        IF SalesSetup."Dupl. Whse. Rel. No. Warning" AND
          (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)
        THEN
            CU414_ValidateWhseReleaseNo(SalesHeader);
        // </TPZ159>

        // <TPZ1145>
        IF Division.GET(SalesHeader."Shortcut Dimension 5 Code") THEN BEGIN
            IF Division."OSR Code Mandatory" THEN
                SalesHeader.TESTFIELD("Salesperson Code");

            IF Division."Mfr. Rep. Code Mandatory" THEN
                SalesHeader.TESTFIELD("Mfr. Rep. Code");
        END;
        // </TPZ1145>

        // <TPZ844>
        IF SalesSetup."One Location per Order" THEN
            CU414_ValidateOneLocation(SalesHeader);
        // </TPZ844>

        // <TPZ884>
        IF PaymentTerms.GET(SalesHeader."Payment Terms Code") AND
           PaymentTerms."Do Not Allow Blind Shipment" AND
          SalesHeader."Blind Shipment"
        THEN
            ERROR(Text51095, PaymentTerms.Code, SalesHeader.FIELDCAPTION("Blind Shipment"));

        IF PaymentTerms.GET(SalesHeader."Payment Terms Code") AND
           PaymentTerms."Do Not Allow Double Bl. Shpt." AND
           SalesHeader."Double Blind Shipment"
        THEN
            ERROR(Text51095, PaymentTerms.Code, SalesHeader.FIELDCAPTION("Double Blind Shipment"));
        // </TPZ884>

        // <TPZ930>
        CU414_ValidateSalesLines(SalesHeader);
        // </TPZ930>

        //<TPZ1942>
        //CheckSalesLineQtyRounding(SalesHeader);
        //</TPZ1942>
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterManualReOpenSalesDoc', '', true, true)]
    local procedure CU414_PerformManualReopen(VAR SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    begin
        CU414_ClearWhseReleaseNo(SalesHeader);//<TPZ2464>
    end;

    procedure CU414_CheckifWhseShptExists(SalesHeader: Record "Sales Header") returnvalue: Boolean;
    var
        SalesLine: Record "Sales Line";
        Location: Record Location;
    begin

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        SalesLine.SETFILTER("No.", '<>%1', '');
        IF SalesLine.FINDFIRST THEN
            REPEAT
                SalesLine.CALCFIELDS(SalesLine."Whse. Outstanding Qty. (Base)");
                IF Location.GET(SalesLine."Location Code") THEN BEGIN
                    IF (Location.RequireShipment(SalesLine."Location Code")) THEN
                        IF SalesLine."Outstanding Qty. (Base)" <= SalesLine."Whse. Outstanding Qty. (Base)" THEN
                            EXIT(TRUE)
                END;
            UNTIL SalesLine.NEXT = 0;

        EXIT(FALSE);
    end;

    procedure CU414_UpdateOutboundWhseRequest(SalesHeader: Record "Sales Header");
    var
        GetSourceDocuments: Report "Get Source Documents";
        WarehouseRequest: Record "Warehouse Request";
        WhseShipmentHeader: Record "Warehouse Shipment Header";
        ReleaseWhseShptDoc: Codeunit "Whse.-Shipment Release";
    begin
        //TMEI BEG 070115 for adding new line to  warehouse shipment document.

        WarehouseRequest.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.");
        WarehouseRequest.SETRANGE("Source Type", DATABASE::"Sales Line");
        WarehouseRequest.SETRANGE("Source Subtype", SalesHeader."Document Type");
        WarehouseRequest.SETRANGE("Source No.", SalesHeader."No.");
        IF WarehouseRequest.FIND('-') THEN BEGIN
            REPEAT
                //WarehouseRequest.SETRANGE("Location Code", WarehouseRequest."Location Code");

                //Synch warehouse shipment document and sales order
                WarehouseRequest.CALCFIELDS("Warehouse Shipment No.");
                IF WarehouseRequest."Warehouse Shipment No." <> '' THEN BEGIN
                    WhseShipmentHeader.GET(WarehouseRequest."Warehouse Shipment No.");
                    CLEAR(GetSourceDocuments);
                    GetSourceDocuments.SetHideDialog(TRUE);
                    GetSourceDocuments.SetSkipBlocked(FALSE);
                    GetSourceDocuments.USEREQUESTPAGE(FALSE);
                    GetSourceDocuments.SETTABLEVIEW(WarehouseRequest);
                    GetSourceDocuments.SetOneCreatedShptHeader(WhseShipmentHeader);
                    GetSourceDocuments.RUNMODAL;

                    /* Pankaj Code commented due to IsSourceDocumentChanged fnction Dekhna hai
                    IF GetSourceDocuments.IsSourceDocumentChanged THEN BEGIN
                        WarehouseRequest."Order Changed" := TRUE;
                        WarehouseRequest.MODIFY;
                    END;
                    */
                END;

            UNTIL WarehouseRequest.NEXT = 0;
        END;
        //TMEI END 070115
    end;

    Procedure CU414_ValidateOneLocation(SalesHeader: Record "Sales Header")
    var
        SalesLineLoc: Record "Sales Line";
        tmpLocation: Record Location;
        item: Record Item;
        HeaderLocation: Record Location;
        InvtSetup: Record "Inventory Setup";
        txtLocationWarning: TextConst ENU = 'The location in Document No. %1 line No. %2 Does not Match the Header information';
    begin
        // <TPZ844>
        SalesLineLoc.RESET;
        SalesLineLoc.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLineLoc.SETRANGE("Document No.", SalesHeader."No.");
        SalesLineLoc.SETRANGE(Type, SalesLineLoc.Type::Item);
        SalesLineLoc.SETFILTER(Quantity, '<>0');
        InvtSetup.GET;
        IF InvtSetup."Location Mandatory" THEN
            IF SalesLineLoc.FINDSET THEN
                REPEAT
                    //<TPZ1568>
                    IF item.GET(SalesLineLoc."No.") THEN BEGIN //<TPZ2482>
                        IF item.Type = item.Type::Inventory THEN BEGIN //<TPZ2482>
                            tmpLocation.GET(SalesLineLoc."Location Code");
                            //<TPZ2648>
                            //        HeaderLocation.GET(SalesHeader."Location Code");//TPZ2648//<TPZ2716> Code Commented
                            IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order") AND (tmpLocation."Non Inventory Location") AND (SalesHeader."Location Code" <> SalesLineLoc."Location Code") THEN
                                MESSAGE(txtLocationWarning, SalesLineLoc."Document No.", SalesLineLoc."Line No.")
                            ELSE
                                //IF (SalesHeader."Document Type"<>SalesHeader."Document Type"::"Return Order") OR  (HeaderLocation."Shipping Location") THEN //TPZ2648//<TPZ2716> Code Commented
                                SalesLineLoc.TESTFIELD("Location Code", SalesHeader."Location Code");
                        END;//<TPZ2482>
                    END;//<TPZ2482>
                UNTIL SalesLineLoc.NEXT = 0;
        // </TPZ844>
    end;

    Procedure CU414_ValidateWhseReleaseNo(SalesHeader: Record "Sales Header")
    var
        LocSalesHeader: Record "Sales Header";
        LocSalesShptHeader: Record "Sales Shipment Header";
        LocSalesInvHeader: Record "Sales Invoice Header";
        Text51004: TextConst ENU = '%1 %2 was already used on Sales Order No. %3 for %4 %5.';
        Text51005: TextConst ENU = '%1 %2 was already used on Posted Sales Shipment No. %3 for %4 %5.';
        Text51006: TextConst ENU = '%1 %2 was already used on Posted Sales Invoice No. %3 for %4 %5.';
    begin
        // <TPZ159>
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND
           (SalesHeader."Location Code" <> '') AND
           (SalesHeader."Warehouse Release No." <> '')
        THEN BEGIN
            LocSalesHeader.RESET;
            LocSalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
            LocSalesHeader.SETFILTER("No.", '<>%1', SalesHeader."No.");
            LocSalesHeader.SETRANGE("Location Code", SalesHeader."Location Code");
            LocSalesHeader.SETRANGE("Warehouse Release No.", SalesHeader."Warehouse Release No.");
            IF LocSalesHeader.FINDFIRST THEN
                ERROR(
                  Text51004,
                  SalesHeader.FIELDCAPTION("Warehouse Release No."),
                  SalesHeader."Warehouse Release No.",
                  LocSalesHeader."No.",
                  SalesHeader.FIELDCAPTION("Location Code"),
                  SalesHeader."Location Code");

            LocSalesShptHeader.RESET;
            LocSalesShptHeader.SETRANGE("Location Code", SalesHeader."Location Code");
            LocSalesShptHeader.SETRANGE("Warehouse Release No.", SalesHeader."Warehouse Release No.");
            IF LocSalesShptHeader.FINDFIRST THEN
                ERROR(
                  Text51005,
                  SalesHeader.FIELDCAPTION("Warehouse Release No."),
                  SalesHeader."Warehouse Release No.",
                  LocSalesShptHeader."No.",
                  SalesHeader.FIELDCAPTION("Location Code"),
                  SalesHeader."Location Code");

            LocSalesInvHeader.RESET;
            LocSalesInvHeader.SETRANGE("Location Code", SalesHeader."Location Code");
            LocSalesInvHeader.SETRANGE("Warehouse Release No.", SalesHeader."Warehouse Release No.");
            IF LocSalesInvHeader.FINDFIRST THEN
                ERROR(
                  Text51006,
                  SalesHeader.FIELDCAPTION("Warehouse Release No."),
                  SalesHeader."Warehouse Release No.",
                  LocSalesInvHeader."No.",
                  SalesHeader.FIELDCAPTION("Location Code"),
                  SalesHeader."Location Code");
        END;
        // </TPZ159>
    end;

    procedure CU414_ValidateOneDivision(SalesHeader: Record "Sales Header")
    var
        SalesLineLoc: Record "Sales Line";
    begin
        // <TPZ1256>
        //SalesHeader.TESTFIELD("Shortcut Dimension 5 Code");  //AJAY
        SalesLineLoc.RESET;
        SalesLineLoc.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLineLoc.SETRANGE("Document No.", SalesHeader."No.");
        SalesLineLoc.SETFILTER(Type, '<>%1', SalesLineLoc.Type::Item);
        SalesLineLoc.SETFILTER(Quantity, '<>0');
        IF SalesLineLoc.FINDSET THEN
            REPEAT
                SalesLineLoc.TESTFIELD("Shortcut Dimension 5 Code", SalesHeader."Shortcut Dimension 5 Code");
            UNTIL SalesLineLoc.NEXT = 0;
        // </TPZ1256>
    end;

    procedure CU414_CreateJobQueueforAutoPick(SalesHeader: Record "Sales Header");
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueCategory: Record "Job Queue Category";
    begin
        //<TPZ2673>
        //WITH SalesHeader DO BEGIN
        JobQueueEntry.INIT();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"Auto Pick";
        JobQueueEntry."Parameter String" := FORMAT(SalesHeader."Document Type") + ',' + SalesHeader."No.";
        JobQueueEntry.ID := CREATEGUID;
        JobQueueCategory.GET('MISC');
        JobQueueEntry."Job Queue Category Code" := 'MISC';
        //JobQueueEntry."Timeout (sec.)" := 7200;
        JobQueueEntry."Maximum No. of Attempts to Run" := 10;//<TPZ3284>
        JobQueueEntry."Earliest Start Date/Time" := CURRENTDATETIME;
        //JobQueueEntry.Priority := 1000;
        JobQueueEntry.Description := salesheader."No.";
        JobQueueEntry.INSERT(TRUE);
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
    END;
    //</TPZ2673>

    procedure CU414_PickEmailExists(VAR SalesHeader: Record "Sales Header"); //return : Boolean
    begin
        /*Lanham code commented Pankaj Dekhna Hai
        //<TPZ2701>
        EMailListEntry.RESET;
        EMailListEntry.SETRANGE("Table ID", DATABASE::Location);
        EMailListEntry.SETRANGE(Code, SalesHeader."Location Code");
        EMailListEntry.SETFILTER("Pick Report E-Mail", '<>%1', EMailListEntry."Pick Report E-Mail"::" ");
        IF EMailListEntry.ISEMPTY THEN
            EXIT(FALSE)
        ELSE
            EXIT(TRUE);
        //</TPZ2701>
        */
    end;

    procedure CU414_CheckSalesLineQtyRounding(VAR pSalesHdr: Record "Sales Header");
    var
        LocalSalesLine: Record "Sales Line";
        LocalItemRec: Record Item;
        LocalRoundedUpQty: Decimal;
        Text51007: TextConst ENU = 'The %1:%2 on %3:%4 is not in the Order Multiple,setup for the %5:%6, It must be rounded up to %7.';
    begin
        //<TPZ1942>
        //WITH LocalSalesLine DO BEGIN
        LocalSalesLine.RESET;
        LocalSalesLine.SETRANGE("Document Type", pSalesHdr."Document Type");
        LocalSalesLine.SETRANGE("Document No.", pSalesHdr."No.");
        LocalSalesLine.SETRANGE(Type, LocalSalesLine.Type::Item);
        IF LocalSalesLine.FINDSET(TRUE, FALSE) THEN
            REPEAT

            /*   LocalItemRec.GET(LocalSalesLine."No.");
              IF (LocalItemRec."Sales Order Multiple" <> 0)
                   AND (LocalSalesLine."Outstanding Quantity" <> 0) //TPZ2899
                   AND (NOT LocalItemRec."Override Sales Order Multiple")  //TPZ2899
                THEN
                  IF (LocalSalesLine.Quantity MOD LocalItemRec."Sales Order Multiple" <> 0) THEN BEGIN
                      LocalRoundedUpQty := LocalItemRec."Sales Order Multiple" * (LocalSalesLine.Quantity DIV LocalItemRec."Sales Order Multiple" + 1);
                      ERROR(Text51007, LocalSalesLine.FIELDCAPTION(Quantity),
                                      LocalSalesLine.Quantity,
                                      LocalSalesLine.TABLECAPTION,
                                      LocalSalesLine."Line No.",
                                      LocalItemRec.TABLECAPTION,
                                      LocalItemRec."No.",
                                      LocalRoundedUpQty);
                  END; *///VAH

            UNTIL (LocalSalesLine.NEXT = 0);
    END;
    //</TPZ1942>

    procedure CU414_CreateJobQueueForSendingPick(SalesHeader: Record "Sales Header");
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueCategory: Record "Job Queue Category";
        WarehouseActivityHeader: Record "Warehouse Activity Header";
    begin
        //<TPZ2701>
        //WITH SalesHeader DO BEGIN

        WarehouseActivityHeader.RESET;
        WarehouseActivityHeader.SETCURRENTKEY("Source Document", "Source No.", "Location Code");
        WarehouseActivityHeader.SETRANGE("Source Document", WarehouseActivityHeader."Source Document"::"Sales Order");
        WarehouseActivityHeader.SETRANGE("Source No.", SalesHeader."No.");
        IF WarehouseActivityHeader.FINDLAST THEN; //EB

        JobQueueEntry.INIT();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"Pick Email Handling";
        JobQueueEntry."Parameter String" := FORMAT(SalesHeader."Document Type") + ',' + SalesHeader."No.";
        JobQueueEntry.ID := CREATEGUID;
        JobQueueCategory.GET('MISC');
        JobQueueEntry."Job Queue Category Code" := 'MISC';
        //JobQueueEntry."Timeout (sec.)" := 7200;
        JobQueueEntry."Earliest Start Date/Time" := CURRENTDATETIME;
        //JobQueueEntry.Priority := 1000;
        JobQueueEntry.Description := FORMAT(SalesHeader."Document Type") + ',' + SalesHeader."No." + ',' + WarehouseActivityHeader."No.";
        JobQueueEntry.INSERT(TRUE);
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
    END;
    //</TPZ2701>

    procedure CU414_ClearWhseReleaseNo(SalesHeader: Record "Sales Header");
    var
        LocationWhse: record location;
    begin
        //<TPZ2464>
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND
          (SalesHeader."Location Code" <> '') AND
          (SalesHeader."Warehouse Release No." <> '')
        THEN BEGIN
            IF LocationWhse.GET(SalesHeader."Location Code") THEN BEGIN
                IF LocationWhse."Enable DMS" = FALSE THEN BEGIN
                    SalesHeader."Warehouse Release No." := '';
                    SalesHeader.MODIFY;
                END;
            END;
        END;
        //</TPZ2464>
    end;

    procedure CU414_CheckGPPG_Dept_UnitPrice(pSalesHeaderRec: Record "Sales Header");
    var
        SalesLine: Record "Sales Line";
        GLSetup: Record "General Ledger Setup";
        ItemRec: Record Item;
    begin
        // <TPZ1682>
        //WITH pSalesHeaderRec DO BEGIN

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", pSalesHeaderRec."Document Type");
        SalesLine.SETRANGE("Document No.", pSalesHeaderRec."No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        SalesLine.SETRANGE(Sample, TRUE);
        IF SalesLine.FINDSET THEN BEGIN
            GLSetup.GET;
            REPEAT
                /*Dekhna haiGLSetup.TESTFIELD(GLSetup."Sample Items Expense G/L Acct.");
                GLSetup.TESTFIELD("Sample Items GPPG Code");
                SalesLine.TESTFIELD("Gen. Prod. Posting Group", GLSetup."Sample Items GPPG Code");
                SalesLine.TESTFIELD("Shortcut Dimension 1 Code", GLSetup."Sample Department Code");
                
                SalesLine.TESTFIELD("Shortcut Dimension 2 Code", GLSetup."Sample Site Code");
                */
                SalesLine.TESTFIELD("Unit Price", 0.0);
                SalesLine.TESTFIELD("Actual Unit Price", 0.0);
            UNTIL SalesLine.NEXT = 0;
        END;

        SalesLine.SETRANGE(Sample, FALSE);
        IF SalesLine.FINDSET THEN
            REPEAT
                ItemRec.GET(SalesLine."No.");
                SalesLine.TESTFIELD("Gen. Prod. Posting Group", ItemRec."Gen. Prod. Posting Group");
            UNTIL SalesLine.NEXT = 0;
    END;
    // </TPZ1682>

    procedure CU414_CheckGPPG_Dept_UnitPrice_Promo(pSalesHeaderRec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        GLSetup: Record "General Ledger Setup";
        ItemRec: Record Item;
    begin
        // <TPZ2368>
        //WITH pSalesHeaderRec DO BEGIN

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", pSalesHeaderRec."Document Type");
        SalesLine.SETRANGE("Document No.", pSalesHeaderRec."No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        SalesLine.SETRANGE(Promo, TRUE);
        IF SalesLine.FINDSET THEN BEGIN
            GLSetup.GET;
            REPEAT
                /*Pankaj Dekhna hai
                GLSetup.TESTFIELD(GLSetup."Promo Items Expense G/L Acct.");
                GLSetup.TESTFIELD("Promo Items GPPG Code");
                SalesLine.TESTFIELD("Gen. Prod. Posting Group", GLSetup."Promo Items GPPG Code");
                SalesLine.TESTFIELD("Shortcut Dimension 1 Code", GLSetup."Promo Department Code");
                SalesLine.TESTFIELD("Shortcut Dimension 2 Code", GLSetup."Promo Site Code");
                */
                SalesLine.TESTFIELD("Unit Price", 0.0);
                SalesLine.TESTFIELD("Actual Unit Price", 0.0);
            UNTIL SalesLine.NEXT = 0;
        END;

        SalesLine.SETRANGE(Promo, FALSE);
        IF SalesLine.FINDSET THEN
            REPEAT
                ItemRec.GET(SalesLine."No.");
                SalesLine.TESTFIELD("Gen. Prod. Posting Group", ItemRec."Gen. Prod. Posting Group");
            UNTIL SalesLine.NEXT = 0;
    END;
    // </TPZ2368>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', true, true)]
    procedure CU414_ValidateSalesLineForUniqueLocation(VAR SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        SalesLineLoc: Record "Sales Line";

    begin
        //TPZ2875
        IF NOT GUIALLOWED THEN
            EXIT;
        IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::"Return Order", SalesHeader."Document Type"::"Credit Memo"] THEN BEGIN
            SalesLineLoc.RESET;
            SalesLineLoc.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLineLoc.SETRANGE("Document No.", SalesHeader."No.");
            SalesLineLoc.SETRANGE(Type, SalesLineLoc.Type::Item);
            SalesLineLoc.SETFILTER("Location Code", '<>%1', SalesHeader."Location Code");
            IF SalesLineLoc.FINDFIRST THEN
                IF NOT CONFIRM(Text001, TRUE, SalesLineLoc."Line No.", SalesHeader."Location Code") THEN
                    ERROR('');
        END;
    end;

    LOCAL procedure CU414_DuplicateSanaPOCheck(VAR rec: Record "Sales Header")
    var
        SalesHeader1: Record "Sales Header";
        SalesInvHeader1: Record "Sales Invoice Header";
        SalesSetup: Record "Sales & Receivables Setup";
        Text51010: TextConst ENU = '%1 %2 was already used on Sales Order No. %3 %4 %5 for Customer No. %6. Do you want to use it again?';
        Text51011: TextConst ENU = '%1 %2 was already used on Posted Sales Invoice No. %3 %4 %5 for Customer No. %6. Do you want to use it again?';
    begin
        //<TPZ3183>
        //WITH rec DO BEGIN
        SalesSetup.GET;
        IF NOT SalesSetup."Dupl. Ext. Doc. No. Warning" THEN
            EXIT;

        IF rec."Unique Webshop Document Id" <> '{00000000-0000-0000-0000-000000000000}' THEN BEGIN
            IF (rec."Document Type" = rec."Document Type"::Order) AND
               (rec."Sell-to Customer No." <> '') AND
               (rec."External Document No." <> '')
            THEN BEGIN
                SalesHeader1.RESET;
                SalesHeader1.SETRANGE("Document Type", rec."Document Type"::Order);
                SalesHeader1.SETFILTER("No.", '<>%1', rec."No.");
                SalesHeader1.SETRANGE("Sell-to Customer No.", rec."Sell-to Customer No.");
                SalesHeader1.SETRANGE("External Document No.", rec."External Document No.");
                IF SalesHeader1.FINDFIRST THEN
                    IF NOT
                         CONFIRM(
                           Text51010,
                           FALSE,
                           rec.FIELDCAPTION("External Document No."),
                           rec."External Document No.",
                           SalesHeader1."No.",
                           rec.FIELDCAPTION("Shortcut Dimension 5 Code"), SalesHeader1."Shortcut Dimension 5 Code",
                           rec."Sell-to Customer No.")
                    THEN
                        ERROR('');
                SalesInvHeader1.RESET;
                SalesInvHeader1.SETRANGE("Sell-to Customer No.", rec."Sell-to Customer No.");
                SalesInvHeader1.SETRANGE("External Document No.", rec."External Document No.");
                IF SalesInvHeader1.FINDFIRST THEN
                    IF NOT
                         CONFIRM(
                           Text51011,
                           FALSE,
                           rec.FIELDCAPTION("External Document No."),
                           rec."External Document No.",
                           SalesInvHeader1."No.",
                             rec.FIELDCAPTION("Shortcut Dimension 5 Code"), SalesInvHeader1."Shortcut Dimension 5 Code",
                           rec."Sell-to Customer No.")
                    THEN
                        ERROR('');
            END;
        END;
    END;
    //</TPZ3183>

    LOCAL procedure CU414_ItemShipRestriction(VAR rec: Record "Sales Header")
    var
        ItemShippingRestriction: Record "Item Shipping Restriction";
        tmpSalesLine: Record "Sales Line";
        CountryRegion: Record "Country/Region";
        County: Record County;
        tmpItem: Record Item;
        BlockedItemRestriction: TextConst ENU = 'Ship-to Country "%1", associated with item"%2" is restricted to Ship. \This Item is  Restricted from being shipped in %1 Country';
        BlockedItemRestriction1: TextConst ENU = 'Ship-to State "%1", associated with item"%2" is restricted to Ship. \This Item is  Restricted from being shipped in %1 State';
        BlockedItemRestriction2: TextConst ENU = 'Shipping Mode "%2" for Shipping Agent "%1", associated with item"%3" is restricted to Ship. \This Item is  Restricted from being shipped by %2 Mode for %1 Shipping Agent';
        BlockedItemRestriction3: TextConst ENU = 'Customer "%1", associated with item"%2" is restricted to Ship. \This Item is  Restricted from being shipped to %1 Customer';
        BlockedItemRestriction4: TextConst ENU = 'Stock  Rep. Location "%1", associated with item"%2" is restricted to Ship. \This Item is  Restricted from being shipped to %1 Location';
    begin

        //<TPZ3151>
        //WITH rec DO BEGIN
        tmpSalesLine.RESET();
        tmpSalesLine.SETRANGE("Document No.", rec."No.");
        tmpSalesLine.SETRANGE(Type, tmpSalesLine.Type::Item);
        IF tmpSalesLine.FIND('-') THEN BEGIN
            REPEAT
                IF tmpItem.GET(tmpSalesLine."No.") THEN BEGIN
                    IF rec."Ship-to Country/Region Code" <> '' THEN BEGIN
                        ItemShippingRestriction.RESET;
                        ItemShippingRestriction.SETRANGE("Item No.", tmpSalesLine."No.");
                        ItemShippingRestriction.SETRANGE("Restriction Type", ItemShippingRestriction."Restriction Type"::Country);
                        ItemShippingRestriction.SETRANGE("Restriction Code 1", rec."Ship-to Country/Region Code");
                        IF ItemShippingRestriction.FINDFIRST THEN
                            ERROR(BlockedItemRestriction, ItemShippingRestriction."Restriction Code 1", tmpItem."No.");
                    END;

                    ItemShippingRestriction.RESET;
                    ItemShippingRestriction.SETRANGE("Item No.", tmpSalesLine."No.");
                    ItemShippingRestriction.SETRANGE("Restriction Type", ItemShippingRestriction."Restriction Type"::State);
                    ItemShippingRestriction.SETRANGE("Restriction Code 1", rec."Ship-to County");
                    IF ItemShippingRestriction.FINDFIRST THEN
                        ERROR(BlockedItemRestriction1, ItemShippingRestriction."Restriction Code 1", tmpItem."No.");

                    ItemShippingRestriction.RESET;
                    ItemShippingRestriction.SETRANGE("Item No.", tmpSalesLine."No.");
                    ItemShippingRestriction.SETRANGE("Restriction Type", ItemShippingRestriction."Restriction Type"::"Shipping Mode");
                    ItemShippingRestriction.SETRANGE("Restriction Code 1", rec."Shipping Agent Code");
                    ItemShippingRestriction.SETRANGE("Restriction Code 2", rec."E-Ship Agent Service");
                    IF ItemShippingRestriction.FINDFIRST THEN
                        ERROR(BlockedItemRestriction2, ItemShippingRestriction."Restriction Code 1", ItemShippingRestriction."Restriction Code 2", tmpItem."No.");

                    ItemShippingRestriction.RESET;
                    ItemShippingRestriction.SETRANGE("Item No.", tmpSalesLine."No.");
                    ItemShippingRestriction.SETRANGE("Restriction Type", ItemShippingRestriction."Restriction Type"::Customer);
                    ItemShippingRestriction.SETRANGE("Restriction Code 1", tmpSalesLine."Sell-to Customer No.");
                    IF ItemShippingRestriction.FINDFIRST THEN
                        ERROR(BlockedItemRestriction3, ItemShippingRestriction."Restriction Code 1", tmpItem."No.");

                    //<TPZ3305>
                    IF rec."Location Code" <> '' THEN BEGIN
                        ItemShippingRestriction.RESET;
                        ItemShippingRestriction.SETRANGE("Item No.", tmpSalesLine."No.");
                        ItemShippingRestriction.SETRANGE("Restriction Type", ItemShippingRestriction."Restriction Type"::"Stock Rep");
                        ItemShippingRestriction.SETRANGE("Restriction Code 1", tmpSalesLine."Location Code");
                        IF ItemShippingRestriction.FINDFIRST THEN
                            ERROR(BlockedItemRestriction4, ItemShippingRestriction."Restriction Code 1", tmpItem."No.");
                    END;
                    //</TPZ3305>
                END;
            UNTIL tmpSalesLine.NEXT = 0;
        END;
    END;
    //</TPZ3151>

    var
        Text001: TextConst ENU = 'The Sales Line %1 has different location code than Sales Header %2. Do you want to proceed?';
        Text51001: TextConst ENU = 'Do you want to round the quantity up to %1 %2 for Line no. %3, Item no. %4';
        TextRNDERROR: TextConst ENU = 'Quantity must be round of %1 for line no. %2, Item no. %3';
        TextApplError: TextConst ENU = 'Document %1 Line No. %2 is not assigned to a related Document - you must delete the line and use the Get Posted Document Lines  Function';
        Text51096: TextConst ENU = 'does not match %1 %2';
}