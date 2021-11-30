codeunit 51409 "Sales-Split Order"
{
    TableNo = "Sales Header";
    /*
        trigger OnRun()
        begin

            Rec.TESTFIELD("Document Type", rec."Document Type"::Order);
            rec.TESTFIELD(Status, rec.Status::Open);
            Location.RESET;
            IF Location.FINDSET THEN
                REPEAT
                    OldSalesLine.RESET;
                    OldSalesLine.SETCURRENTKEY("Document Type", "Document No.", "Location Code");
                    OldSalesLine.SETRANGE("Document Type", rec."Document Type");
                    OldSalesLine.SETRANGE("Document No.", rec."No.");
                    OldSalesLine.SETRANGE(Type, OldSalesLine.Type::Item);
                    OldSalesLine.SETRANGE("Location Code", Location.Code);
                    OldSalesLine.SETFILTER("Outstanding Quantity", '>0');

                    IF (Location.Code <> rec."Location Code") AND
                   OldSalesLine.FIND('-')
                THEN
                        REPEAT
                            NewSalesLine.LOCKTABLE;

                            IF (PrevLocationCode = '') OR
                              (Location.Code <> PrevLocationCode)
                            THEN BEGIN
                                NewSalesHeader.INIT;
                                NewSalesHeader."Document Type" := rec."Document Type";
                                NewSalesHeader."No." := '';
                                NewSalesHeader.INSERT(TRUE);

                                NewSalesLine.SETRANGE("Document Type", rec."Document Type");
                                NewSalesLine.SETRANGE("Document No.", rec."No.");

                                NewSalesHeader.TRANSFERFIELDS(Rec, FALSE);
                                //<TPZ1530>
                                NewSalesHeader."Shipment Date" := WORKDATE;
                                //</TPZ1530>
                                //<TPZ3324>
                                NewSalesHeader.VALIDATE("Shipment Date", rec."Shipment Date");
                                NewSalesHeader.VALIDATE("Posting Date", rec."Posting Date");
                                //</TPZ3324>

                                //<TPZ1640>
                                NewSalesHeader.VALIDATE("Document Date", WORKDATE);
                                //<TPZ1640>  -
                                //<TPZ9541>
                                NewSalesHeader.VALIDATE("Posting Date", WORKDATE);
                                //<TPZ9541>
                                NewSalesHeader."Last Shipping No." := '';
                                // <TOP8624>
                                NewSalesHeader."Shipping No." := '';
                                NewSalesHeader."Posting No." := '';
                                // <TOP8624>
                                //<TPZ1655>
                                NewSalesHeader."Warehouse Release No." := '';
                                //</TPZ1655>
                                NewSalesHeader.Status := NewSalesHeader.Status::Open;
                                NewSalesHeader.Invoice := FALSE;
                                NewSalesHeader.Ship := FALSE;
                                NewSalesHeader.VALIDATE("Location Code", Location.Code);
                                NewSalesHeader."No. Printed" := 0;

                                NewSalesHeader."Master Order No." := rec."No.";

                                IF rec."Free Freight" THEN BEGIN
                                    SalesSetup.GET;
                                    SalesSetup.TESTFIELD(SalesSetup."Split Order F. F. Reason Code");
                                    NewSalesHeader."Free Freight Reason Code" := SalesSetup."Split Order F. F. Reason Code";
                                    //<TPZ2120>
                                    rec."Free Freight Reason Code" := SalesSetup."Split Order F. F. Reason Code";
                                    rec.MODIFY();
                                    //</TPZ2120>
                                END;

                                NewSalesHeader.MODIFY;

                                CopyCommentLines(
                                  rec."Document Type",
                                  NewSalesHeader."Document Type",
                                  rec."No.",
                                  NewSalesHeader."No.");

                                SplitCount := SplitCount + 1;
                            END;

                            CopyEmailList(rec."No.", NewSalesHeader."No.");//<TPZ1676>//EB

                            CopySalesLine(NewSalesHeader, NewSalesLine, Rec, OldSalesLine);

                            OldSalesLine.VALIDATE(Quantity, OldSalesLine."Quantity Shipped");
                            OldSalesLine.VALIDATE("Location Code", '');
                            OldSalesLine.MODIFY(TRUE);

                            PrevLocationCode := Location.Code;
                        UNTIL OldSalesLine.NEXT = 0;
                UNTIL Location.NEXT = 0;

            IF GUIALLOWED THEN
                IF SplitCount > 0 THEN
                    MESSAGE(Text51400, "Document Type", "No.", SplitCount + 1)
                ELSE
                    ERROR(Text51401);
        end;

        LOCAL procedure CopySalesLine(VAR ToSalesHeader: Record "Sales Header"; VAR ToSalesLine: Record "Sales Line"; VAR FromSalesHeader: Record "Sales Header"; VAR FromSalesLine: Record "Sales Line")
        begin
            ToSalesLine.SetSalesHeader(ToSalesHeader);
            ToSalesLine.INIT;
            ToSalesLine."Document Type" := ToSalesHeader."Document Type";
            ToSalesLine."Document No." := ToSalesHeader."No.";
            ToSalesLine."Line No." := FromSalesLine."Line No.";

            UpdateSalesLine(ToSalesHeader, ToSalesLine, FromSalesHeader, FromSalesLine);

            ToSalesLine."Shortcut Dimension 1 Code" := FromSalesLine."Shortcut Dimension 1 Code";
            ToSalesLine."Shortcut Dimension 2 Code" := FromSalesLine."Shortcut Dimension 2 Code";
            ToSalesLine."Shortcut Dimension 5 Code" := FromSalesLine."Shortcut Dimension 5 Code";
            ToSalesLine."Dimension Set ID" := FromSalesLine."Dimension Set ID";

            //<TPZ1427>
            ToSalesLine."External Document Line No." := FromSalesLine."External Document Line No.";
            //</TPZ1427>

            ToSalesLine.INSERT;
        end;

        LOCAL procedure UpdateSalesLine(VAR ToSalesHeader: Record "Sales Header"; VAR ToSalesLine: Record "Sales Line"; VAR FromSalesHeader: Record "Sales Header"; VAR FromSalesLine: Record "Sales Line")
        begin
            ToSalesLine.VALIDATE(Type, FromSalesLine.Type);

            //<TPZ2211>
            //ToSalesLine.VALIDATE(Description,FromSalesLine.Description);
            //ToSalesLine.VALIDATE("Description 2",FromSalesLine."Description 2");
            ToSalesLine.Description := FromSalesLine.Description;
            ToSalesLine."Description 2" := FromSalesLine."Description 2";
            //</TPZ2211>

            IF (FromSalesLine.Type <> 0) AND (FromSalesLine."No." <> '') THEN BEGIN
                ToSalesLine.VALIDATE("No.", FromSalesLine."No.");
                ToSalesLine.VALIDATE("Location Code", FromSalesLine."Location Code");
                ToSalesLine.VALIDATE("Unit of Measure", FromSalesLine."Unit of Measure");
                ToSalesLine.VALIDATE("Unit of Measure Code", FromSalesLine."Unit of Measure Code");
                ToSalesLine.VALIDATE(Quantity, FromSalesLine."Outstanding Quantity");

                ToSalesLine.VALIDATE("Unit Price", FromSalesLine."Unit Price");
                ToSalesLine.VALIDATE("Line Discount %", FromSalesLine."Line Discount %");
                // <TPZ1613>
                ToSalesLine."Quote No." := FromSalesLine."Quote No.";
                ToSalesLine."Quote Line No." := FromSalesLine."Quote Line No.";
                // <TPZ1613>

            END;
            IF (FromSalesLine.Type = FromSalesLine.Type::" ") AND (FromSalesLine."No." <> '') THEN
                ToSalesLine.VALIDATE("No.", FromSalesLine."No.");
            // <TPZ1107>
            ToSalesLine.VALIDATE(Sample, FromSalesLine.Sample);
            // </TPZ1107>
            //<TPZ2368>
            ToSalesLine.VALIDATE(Promo, FromSalesLine.Promo);
            //</TPZ2368>
        end;

        LOCAL procedure CopyCommentLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
        begin
            OldSalesCommentLine.RESET;
            OldSalesCommentLine.SETRANGE("Document Type", FromDocumentType);
            OldSalesCommentLine.SETRANGE("No.", FromNumber);
            IF OldSalesCommentLine.FINDSET THEN
                REPEAT
                    NewSalesCommentLine := OldSalesCommentLine;
                    NewSalesCommentLine."Document Type" := ToDocumentType;
                    NewSalesCommentLine."No." := ToNumber;
                    NewSalesCommentLine.INSERT;
                UNTIL OldSalesCommentLine.NEXT = 0;
        end;

        LOCAL procedure CopyEmailList(FromNumber: Code[20]; ToNumber: Code[20])
        begin
            //<TPZ1676>
            EmailList.RESET;
            EmailList.SETRANGE("Table ID", 36);
            EmailList.SETRANGE(Type, 1);
            EmailList.SETRANGE(Code, ToNumber);
            IF NOT EmailList.FINDFIRST THEN BEGIN
                OldEmailList.RESET;
                OldEmailList.SETRANGE("Table ID", 36);
                OldEmailList.SETRANGE(Type, 1);
                OldEmailList.SETRANGE(Code, FromNumber);
                IF OldEmailList.FINDSET THEN
                    REPEAT
                        NewEmailList := OldEmailList;
                        NewEmailList.Code := ToNumber;
                        NewEmailList.INSERT;
                    UNTIL OldEmailList.NEXT = 0;
            END;
            //</TPZ1676>
        end;

        procedure CreateSplitOrder(VAR PsalesHeader: Record "Sales Header")
        begin
            //<TPZ2782>
            SalesLineLoc.RESET;
            SalesLineLoc.SETRANGE("Document Type", PsalesHeader."Document Type");
            SalesLineLoc.SETRANGE("Document No.", PsalesHeader."No.");
            SalesLineLoc.SETRANGE(Type, SalesLineLoc.Type::Item);
            SalesLineLoc.SETFILTER("Outstanding Quantity", '>0');
            IF SalesLineLoc.FINDSET THEN BEGIN
                REPEAT
                    QtyAvailQtyAvailToPick := 0;
                    IF Item.GET(SalesLineLoc."No.") THEN BEGIN
                        IF Location.GET(SalesLineLoc."Location Code") AND
                            NOT Location."Bin Mandatory"
                        THEN BEGIN
                            Item.SETRANGE("Variant Filter", SalesLineLoc."Variant Code");
                            Item.SETRANGE("Location Filter", SalesLineLoc."Location Code");
                            Item.CALCFIELDS(Inventory, "Qty. on Sales Order");
                            QtyAvailQtyAvailToPick := Item.Inventory - Item."Qty. on Sales Order";
                        END ELSE
                            QtyAvailQtyAvailToPick := WhseCreatePick.QtyAvailtoPick(SalesLineLoc."No.", SalesLineLoc."Location Code");
                    END;

                    IF QtyAvailQtyAvailToPick <= 0 THEN BEGIN

                        SalesLineTemp.INIT;
                        SalesLineTemp := SalesLineLoc;
                        SalesLineTemp.INSERT;

                    END;
                UNTIL SalesLineLoc.NEXT = 0;
            END;

            IF SalesLineTemp.FINDSET THEN BEGIN
                IF SplitCOunt = 0 THEN BEGIN
                    IF GUIALLOWED THEN
                        IF NOT CONFIRM(Text51402, FALSE) THEN
                            EXIT;
                END;
                NewSalesLine.LOCKTABLE;
                NewSalesHeader.INIT;
                NewSalesHeader."Document Type" := PsalesHeader."Document Type";
                NewSalesHeader."No." := '';
                NewSalesHeader.INSERT(TRUE);

                NewSalesLine.SETRANGE("Document Type", PsalesHeader."Document Type");
                NewSalesLine.SETRANGE("Document No.", PsalesHeader."No.");

                NewSalesHeader.TRANSFERFIELDS(PsalesHeader, FALSE);

                NewSalesHeader."Shipment Date" := WORKDATE;
                NewSalesHeader.VALIDATE("Document Date", WORKDATE);
                NewSalesHeader.VALIDATE("Posting Date", WORKDATE);
                NewSalesHeader."Last Shipping No." := '';
                NewSalesHeader."Shipping No." := '';
                NewSalesHeader."Posting No." := '';
                NewSalesHeader."Warehouse Release No." := '';
                NewSalesHeader.Status := NewSalesHeader.Status::Open;
                NewSalesHeader.Invoice := FALSE;
                NewSalesHeader.Ship := FALSE;
                NewSalesHeader.VALIDATE("Location Code", Location."Backup Location Code");
                NewSalesHeader."No. Printed" := 0;

                NewSalesHeader."Master Order No." := PsalesHeader."No.";

                IF PsalesHeader."Free Freight" THEN BEGIN
                    SalesSetup.GET;
                    SalesSetup.TESTFIELD(SalesSetup."Split Order F. F. Reason Code");
                    NewSalesHeader."Free Freight Reason Code" := SalesSetup."Split Order F. F. Reason Code";
                    PsalesHeader."Free Freight Reason Code" := SalesSetup."Split Order F. F. Reason Code";
                    PsalesHeader.MODIFY();
                END;

                NewSalesHeader.MODIFY;

                CopyCommentLines(
                  PsalesHeader."Document Type",
                  NewSalesHeader."Document Type",
                  PsalesHeader."No.",
                  NewSalesHeader."No.");

                SplitCOunt := SplitCOunt + 1;

                CopyEmailList(PsalesHeader."No.", NewSalesHeader."No.");

                REPEAT
                    CopySalesLine1(NewSalesHeader, NewSalesLine, PsalesHeader, SalesLineTemp, Location);
                    IF SalesLineLoc.GET(SalesLineTemp."Document Type", SalesLineTemp."Document No.", SalesLineTemp."Line No.") THEN BEGIN
                        SalesLineLoc.VALIDATE(Quantity, OldSalesLine."Quantity Shipped");
                        SalesLineLoc.VALIDATE("Location Code", '');
                        SalesLineLoc.MODIFY(TRUE);
                    END;
                UNTIL SalesLineTemp.NEXT = 0;
            END;
            SalesLineTemp.DELETEALL;

            IF GUIALLOWED THEN
                IF SplitCOunt > 0 THEN
                    MESSAGE(Text51400, PsalesHeader."Document Type", PsalesHeader."No.", SplitCOunt + 1);
            //</TPZ2782>
        end;

        LOCAL procedure CopySalesLine1(VAR ToSalesHeader: Record "Sales Header"; VAR ToSalesLine: Record "Sales Line"; VAR FromSalesHeader: Record "Sales Header"; VAR FromSalesLine: Record "Sales Line"; VAR Ploc: Record Location)
        begin
            //<TPZ2782>
            ToSalesLine.SetSalesHeader(ToSalesHeader);
            ToSalesLine.INIT;
            ToSalesLine."Document Type" := ToSalesHeader."Document Type";
            ToSalesLine."Document No." := ToSalesHeader."No.";
            ToSalesLine."Line No." := FromSalesLine."Line No.";

            UpdateSalesLine1(ToSalesHeader, ToSalesLine, FromSalesHeader, FromSalesLine, Ploc);

            ToSalesLine."Shortcut Dimension 1 Code" := FromSalesLine."Shortcut Dimension 1 Code";
            ToSalesLine."Shortcut Dimension 2 Code" := FromSalesLine."Shortcut Dimension 2 Code";
            ToSalesLine."Shortcut Dimension 5 Code" := FromSalesLine."Shortcut Dimension 5 Code";
            ToSalesLine."Dimension Set ID" := FromSalesLine."Dimension Set ID";
            ToSalesLine."External Document Line No." := FromSalesLine."External Document Line No.";

            ToSalesLine.INSERT;
            //</TPZ2782>
        end;

        LOCAL procedure UpdateSalesLine1(VAR ToSalesHeader: Record "Sales Header"; VAR ToSalesLine: Record "Sales Line"; VAR FromSalesHeader: Record "Sales Header"; VAR FromSalesLine: Record "Sales Line"; VAR Ploc1: Record Location)
        begin
            //<TPZ2782>
            ToSalesLine.VALIDATE(Type, FromSalesLine.Type);
            ToSalesLine.Description := FromSalesLine.Description;
            ToSalesLine."Description 2" := FromSalesLine."Description 2";
            IF (FromSalesLine.Type <> 0) AND (FromSalesLine."No." <> '') THEN BEGIN
                ToSalesLine.VALIDATE("No.", FromSalesLine."No.");
                ToSalesLine.VALIDATE("Location Code", Ploc1."Backup Location Code");
                ToSalesLine.VALIDATE("Unit of Measure", FromSalesLine."Unit of Measure");
                ToSalesLine.VALIDATE("Unit of Measure Code", FromSalesLine."Unit of Measure Code");
                ToSalesLine.VALIDATE(Quantity, FromSalesLine."Outstanding Quantity");
                ToSalesLine.VALIDATE("Unit Price", FromSalesLine."Unit Price");
                ToSalesLine.VALIDATE("Line Discount %", FromSalesLine."Line Discount %");
                ToSalesLine."Quote No." := FromSalesLine."Quote No.";
                ToSalesLine."Quote Line No." := FromSalesLine."Quote Line No.";
            END;
            IF (FromSalesLine.Type = FromSalesLine.Type::" ") AND (FromSalesLine."No." <> '') THEN
                ToSalesLine.VALIDATE("No.", FromSalesLine."No.");
            ToSalesLine.VALIDATE(Sample, FromSalesLine.Sample);
            ToSalesLine.VALIDATE(Promo, FromSalesLine.Promo);
            //</TPZ2782>
        end;

        var
            SalesSetup: Record "Sales & Receivables Setup";
            Location: Record Location;
            NewSalesHeader: Record "Sales Header";
            OldSalesLine: Record "Sales Line";
            NewSalesLine: Record "Sales Line";
            OldSalesCommentLine: Record "Sales Comment Line";
            NewSalesCommentLine: Record "Sales Comment Line";
            SplitCount: Integer;
            PrevLocationCode: Code[10];
        //OldEmailList:	Record	"E-Mail List Entry"	
        //NewEmailList:	Record	"E-Mail List Entry";	
        //EmailList:	Record	"E-Mail List Entry";	
        */
}
