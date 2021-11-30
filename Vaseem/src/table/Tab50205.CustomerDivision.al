table 50205 "Customer Division"
{
    // version TOP140,100B,110,150,TOPFIX,TPZ1342,RS1.07,TPZ2651,TPZ2696,TPZ2715

    // TOP100B KT ABCSI Item Cust. Avail. & Price 03182015
    //   - Added new field Multiplier
    // 
    // TOP110 KT ABCSI Salesperson 03302015
    //   - Added new fields 50100 Mfr. Rep. Code, 50101 ISR Code, 50102 CSR Code
    // 
    // TOP150 - KT ABCSI Sales Order Margin Review 04032015
    //   - Added field # 10 Margin Approval %
    // 
    // TOP140 KT ABCSI - Payment Terms for Multiple Divisions 06032015
    //   - Fixed the validation code on OnValidate trigger of Shortcut Dimension 5 Code field
    // 
    // 2015-04-03 TPZ572 VCHERNYA
    //   RSM Code, OSR Code (Salesperson Code), and Location Code fields have been created
    // 2015-04-30 TPZ161 VCHERNYA
    //   Our Account No., Shipping Agent Code, E-Ship Agent Service, Free Freight, Shipping Payment Type fields have been created
    // 2015-05-29 TPZ573 VCHERNYA
    //   Free Freight Min. Order Amount field has been created
    // 2015-06-11 TPZ439 VCHERNYA
    //   Type filter has been added to Payment Terms Code field table relation
    // 2015-11-01 TPZ1117 TAKHMETO
    //   Payment Terms Code to Print field has been added
    // 2015-12-21 TPZ1342 VCHERNYA
    //   Shipping Advice field has been created
    // 2016-06-17 TPZ1554 EBAGIM
    //   Update Location code in the Ship-to division
    // 2019-10-23 TPZ2651 VAHAMAD
    //   Added Flow Fields "LED Fixtures Scaler" and "LED Lamps Scaler"
    // 2019-10-25 TPZ2696 RTIWARI
    //   Three new fields added viz. Rebate Percentage,Buying Group Code and Customer Group Code
    // 2019-11-27 TPZ2715 RTIWARI
    //   Code added to show warning message in case of change in Multiplier


    fields
    {
        field(1; "Customer No."; Code[20])
        {
            CaptionML = ENU = 'Customer No.',
                        ESM = 'Nº cliente',
                        FRC = 'N° client',
                        ENC = 'Customer No.';
            TableRelation = Customer;
        }
        field(2; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';

            trigger OnLookup();
            begin
                LookupShortcutDimCode(5, "Shortcut Dimension 5 Code"); //TOP140 KT ABCSI Modification to Payment Terms 01222015
            end;

            trigger OnValidate();
            var
                ShiptoDivision: Record "Ship-to Address Division";
                ShiptoAddress: Record "Ship-to Address";
            begin
                GLSetup.GET;
                //TOP140 KT ABCSI - Payment Terms for Multiple Divisions 06032015
                GLSetup.TESTFIELD("Shortcut Dimension 5 Code");
                if not DimVal.GET(GLSetup."Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code") then
                    //TOP140 KT ABCSI - Payment Terms for Multiple Divisions 06032015
                    FIELDERROR("Shortcut Dimension 5 Code", ab001);

                //<TPZ1554>
                ShiptoAddress.SETRANGE("Customer No.", "Customer No.");
                if ShiptoAddress.FINDFIRST then
                    repeat
                        ShiptoDivision.SETRANGE("Customer No.", "Customer No.");
                        ShiptoDivision.SETRANGE("Ship-to Code", ShiptoAddress.Code);
                        ShiptoDivision.SETRANGE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");
                        if not ShiptoDivision.FINDFIRST then
                            repeat
                                ShiptoDivision.INIT();

                                ShiptoDivision.VALIDATE("Customer No.", "Customer No.");
                                ShiptoDivision.VALIDATE("Ship-to Code", ShiptoAddress.Code);
                                ShiptoDivision.VALIDATE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");
                                ShiptoDivision.INSERT();
                            until ShiptoDivision.NEXT = 0;
                    until ShiptoAddress.NEXT = 0;
                //</TPZ1554>
            end;
        }
        field(3; "Payment Terms Code"; Code[10])
        {
            CaptionML = ENU = 'Payment Terms Code',
                        ESM = 'Cód. términos pago',
                        FRC = 'Code modalités de paiement',
                        ENC = 'Payment Terms Code';
            TableRelation = "Payment Terms" WHERE(Type = FILTER(" " | Sales));
        }
        field(4; Multiplier; Decimal)
        {
            DecimalPlaces = 3 : 3;
            Description = 'TOP100B';
            MaxValue = 1;
            MinValue = 0;

            trigger OnValidate();
            begin
                //<TPZ2715>
                if Multiplier <> xRec.Multiplier then
                    if not CONFIRM(Text50001, false,
                              FIELDCAPTION("Customer No."), "Customer No.", FIELDCAPTION("Shortcut Dimension 5 Code"), "Shortcut Dimension 5 Code") then
                        ERROR('');
                //</TPZ2715>
            end;
        }
        field(10; "Margin Approval %"; Decimal)
        {
            Description = 'TOP150';
        }
        field(14; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
        }
        field(29; "Salesperson Code"; Code[10])
        {
            Caption = 'OSR Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(31; "Shipping Agent Code"; Code[10])
        {
            CaptionML = ENU = 'Shipping Agent Code',
                        ESM = 'Cód. transportista',
                        FRC = 'Code agent de livraison',
                        ENC = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate();
            begin
                // <TPZ161>
                SalesSetup.GET;
                if ("Shipping Agent Code" <> xRec."Shipping Agent Code") and SalesSetup."Enable Shipping" then
                    if "Shipping Agent Code" = '' then
                        "E-Ship Agent Service" := ''
                    else begin
                        ShippingAgent.GET("Shipping Agent Code");
                        Cust.GET("Customer No.");
                        // VALIDATE(
                        //   "E-Ship Agent Service",
                        //   EShipAgentService.DefaultShipAgentService(ShippingAgent, Cust."Country/Region Code"));//TODO:
                    end;
                // </TPZ161>
            end;
        }
        field(5750; "Shipping Advice"; Option)
        {
            Caption = 'Shipping Advice';
            OptionCaption = 'Partial,Complete,No Back Order';
            OptionMembers = Partial,Complete,"No Back Order";
        }
        field(50000; "Payment Terms Code to Print"; Code[10])
        {
            Caption = 'Payment Terms Code to Print';
            TableRelation = "Payment Terms";
        }
        field(50035; "RSM Code"; Code[10])
        {
            CalcFormula = Lookup(Customer."RSM Code" WHERE("No." = FIELD("Customer No.")));
            CaptionML = ENU = 'RSM Code',
                        ENC = 'RSM Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Salesperson/Purchaser";
        }
        field(50036; "LED Fixtures Scaler"; Decimal)
        {
            //CalcFormula = Average("Scaler Sales Data"."Scaler Value" WHERE("Customer No." = FIELD("Customer No."),
            //"Scaler Code" = CONST('LED FIXTURE SCALER'),
            //"Shortcut Dimension 5 Code" = FIELD("Shortcut Dimension 5 Code")));//TODO:
            Description = 'TPZ2651';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50037; "LED Lamps Scaler"; Decimal)
        {
            // CalcFormula = Average("Scaler Sales Data"."Scaler Value" WHERE("Customer No." = FIELD("Customer No."),
            //                                                                 "Scaler Code" = CONST('LED LAMPS SCALER'),
            //                                                                 "Shortcut Dimension 5 Code" = FIELD("Shortcut Dimension 5 Code")));//TODO:
            Description = 'TPZ2651';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50040; "Rebate Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'TPZ2696';
        }
        field(50041; "Buying Group Code"; Code[10])
        {
            CalcFormula = Lookup(Customer."Buying Group Code" WHERE("No." = FIELD("Customer No.")));
            Description = 'TPZ2696';
            Editable = false;
            FieldClass = FlowField;
            //TableRelation = "Buying Group";//TODO:
        }
        field(50042; "Customer Group Code"; Code[10])
        {
            CalcFormula = Lookup(Customer."Customer Group Code" WHERE("No." = FIELD("Customer No.")));
            Description = 'TPZ2696';
            Editable = false;
            FieldClass = FlowField;
            // TableRelation = "Customer Group";//TODO:
        }
        field(50100; "Mfr. Rep. Code"; Code[20])
        {
            Description = 'TOP110';
            //TableRelation = "Mfr. Rep.";//TODO:
        }
        field(50101; "ISR Code"; Code[10])
        {
            Description = 'TOP110';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50102; "CSR Code"; Code[10])
        {
            Description = 'TOP110';
            TableRelation = "Salesperson/Purchaser";
        }
        field(51400; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate();
            var
                ShiptoDivision: Record "Ship-to Address Division";
            begin
                //<TPZ1554>
                if CONFIRM('Would you like to update all Ship-to Divisions for Customer ' + "Customer No." + ' Division ' + "Shortcut Dimension 5 Code") then begin
                    ShiptoDivision.SETRANGE("Customer No.", "Customer No.");
                    ShiptoDivision.SETRANGE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");
                    if ShiptoDivision.FINDFIRST then
                        repeat
                            ShiptoDivision.VALIDATE("Location Code", "Location Code");
                            ShiptoDivision.MODIFY();
                        until ShiptoDivision.NEXT = 0;
                end;
                //</TPZ1554>
            end;
        }
        field(51407; "Free Freight Min. Order Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Free Freight Min. Order Amount';
            MinValue = 0;
        }
        field(51408; "Customer Name"; Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            FieldClass = FlowField;
        }
        field(51409; City; Text[30])
        {
            CalcFormula = Lookup(Customer.City WHERE("No." = FIELD("Customer No.")));
            FieldClass = FlowField;
        }
        field(51410; District; Text[30])
        {
            CalcFormula = Lookup(Customer.District WHERE("No." = FIELD("Customer No.")));
            Caption = 'County';
            FieldClass = FlowField;
        }
        field(51411; "Post Code"; Text[20])
        {
            CalcFormula = Lookup(Customer."Post Code" WHERE("No." = FIELD("Customer No.")));
            Caption = 'Zip Code';
            FieldClass = FlowField;
        }
        field(51412; County; Text[30])
        {
            CalcFormula = Lookup(Customer.County WHERE("No." = FIELD("Customer No.")));
            FieldClass = FlowField;
        }
        field(14000701; "E-Ship Agent Service"; Code[30])
        {
            Caption = 'E-Ship Agent Service';
            // TableRelation = "E-Ship Agent Service".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));//TODO:

            trigger OnValidate();
            begin
                // <TPZ161>
                if "E-Ship Agent Service" <> '' then begin
                    TESTFIELD("Shipping Agent Code");
                    ShippingAgent.GET("Shipping Agent Code");
                    Cust.GET("Customer No.");
                    //EShipAgentService.ValidateEShipAgentService(ShippingAgent, "E-Ship Agent Service", Cust."Country/Region Code");//TODO:
                end;
                // </TPZ161>
            end;
        }
        field(14000702; "Free Freight"; Boolean)
        {
            Caption = 'Free Freight';
        }
        field(14000708; "Shipping Payment Type"; Option)
        {
            Caption = 'Shipping Payment Type';
            OptionCaption = 'Prepaid,Third Party,Freight Collect,Consignee';
            OptionMembers = Prepaid,"Third Party","Freight Collect",Consignee;

            trigger OnValidate();
            begin
                // <TPZ161>
                //if ShippingAgent.GET("Shipping Agent Code") then
                // ShippingAccount.ValidateShippingAccount(
                //   ShippingAgent, "Shipping Payment Type", ShippingAccount."Ship-to Type"::Customer, "Customer No.", '');//TODO:
                // </TPZ161>
            end;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Shortcut Dimension 5 Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        PushUpdateToCustomer(Rec); //RS1.07
    end;

    trigger OnModify();
    begin
        PushUpdateToCustomer(Rec); //RS1.07
    end;

    var
        PaymentTerms: Record "Payment Terms";
        "****ABCSI Globals****": Integer;
        DimMgt: Codeunit DimensionManagement;
        DimVal: Record "Dimension Value";
        ab001: Label 'is not valid.';
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        ShippingAgent: Record "Shipping Agent";
        // EShipAgentService: Record "E-Ship Agent Service";//TODO:
        // ShippingAccount: Record "Shipping Account";//TODO:
        Text50001: Label 'Are you sure that you want to change the base customer multiplier for %1 %2, %3 %4.';

    procedure "****ABCSI Functions****"();
    begin
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin

        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
    end;

    procedure PushUpdateToCustomer(var CustomerDivision: Record "Customer Division");
    var
        Customer: Record Customer;
    begin
        //>>RS1.07
        if Customer.GET(CustomerDivision."Customer No.") then begin
            case CustomerDivision."Shortcut Dimension 5 Code" of
                'E':
                    begin

                        Customer."Electric Mfr. Rep. Code" := CustomerDivision."Mfr. Rep. Code";
                        Customer."Electric ISR Code" := CustomerDivision."ISR Code";
                        Customer."Electric CSR Code" := CustomerDivision."CSR Code";
                        Customer."Electric Salesperson Code" := CustomerDivision."Salesperson Code";
                        Customer.MODIFY;

                    end;
                'L':
                    begin

                        Customer."Lighting Mfr. Rep. Code" := CustomerDivision."Mfr. Rep. Code";
                        Customer."Lighting ISR Code" := CustomerDivision."ISR Code";
                        Customer."Lighting CSR Code" := CustomerDivision."CSR Code";
                        Customer."Lighting Salesperson Code" := CustomerDivision."Salesperson Code";
                        Customer.MODIFY;

                    end;
                'P':
                    begin

                        Customer."Conduit Mfr. Rep. Code" := CustomerDivision."Mfr. Rep. Code";
                        Customer."Conduit ISR Code" := CustomerDivision."ISR Code";
                        Customer."Conduit CSR Code" := CustomerDivision."CSR Code";
                        Customer."Conduit Salesperson Code" := CustomerDivision."Salesperson Code";
                        Customer.MODIFY;

                    end;
            end;
        end;
        //<<RS1.07
    end;
}

