pageextension 50201 "TPZItemList" extends "Item List"
{
    // version NAVW111.00.00.40505,NAVNA11.00.00.40505,TPZ2590,TPZ2632,2777,3125

    layout
    {



        modify(Type)
        {
            Visible = false;
        }

        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        modify(Control3)
        {
            Visible = false;
        }
        modify(Control26)
        {
            Visible = false;
        }

        addafter(Description)
        {
            field("Description 2"; "Description 2")
            {
            }
            field("'...'"; '...')
            {
                Caption = 'Inventory By Location';
                Image = ItemAvailbyLoc;
                LookupPageID = "Items by Location Matrix";



                trigger OnDrillDown();
                var
                    ItemsByLocationMatrix: Page "Items by Location Matrix";
                begin
                    //<VSO2183>
                    /*
                    SetColumns(MATRIX_SetWanted::Initial);
                    SetColumns(MATRIX_SetWanted::Same);
                    ItemsByLocationMatrix.Load(MATRIX_CaptionSet, MatrixRecords, MatrixRecord, 0);
                    */// TODO:
                    ItemsByLocationMatrix.SETRECORD(Rec);
                    ItemsByLocationMatrix.RUNMODAL;
                    //</VSO2183
                end;

                trigger OnLookup(var Text: Text): Boolean
                var
                    ItemsByLocationMatrix: Page "Items by Location Matrix";
                begin
                    //<VSO2183>
                    /*
                    SetColumns(MATRIX_SetWanted::Initial);
                    SetColumns(MATRIX_SetWanted::Same);
                    ItemsByLocationMatrix.Load(MATRIX_CaptionSet, MatrixRecords, MatrixRecord, 0);
                    *///TODO:
                    ItemsByLocationMatrix.SETRECORD(Rec);
                    ItemsByLocationMatrix.RUNMODAL;
                    //</VSO2183>
                end;

                trigger OnValidate();
                var
                    ItemsByLocationMatrix: Page "Items by Location Matrix";
                begin
                end;
            }
            field(Hot; Hot)
            {
                Visible = false;
            }
        }
        addafter("Base Unit of Measure")
        {
            field("Alt. Base Unit of Measure"; "Alt. Base Unit of Measure")
            {
                Visible = false;
            }
            field("Country/Region of Origin Code"; "Country/Region of Origin Code")
            {
            }
        }
        addafter("Shelf No.")
        {
            field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code")
            {
            }
        }
        addafter("Standard Cost")
        {
            field("Prior Generation"; "Prior Generation")
            {
            }
            field("Next Generation"; "Next Generation")
            {
            }


            field(QtyAvailtoPick; QtyAvailtoPick)
            {
                Caption = 'Qty Available to Pick';
            }
        }
        addafter("Unit Cost")
        {
            field("Average Unit Cost"; "Average Unit Cost")
            {
            }
        }
        addafter("Item Disc. Group")
        {
            field("Price Book Code"; "Price Book Code")
            {
            }
        }
        addafter("Item Category Code")
        {
            field("Manufacturer Code"; "Manufacturer Code")
            {
                Visible = false;
            }
        }
        addafter(Blocked)
        {
            field("Blocked Reason Code"; "Blocked Reason Code")
            {
            }
            field("Blocked Sequence"; "Blocked Sequence")
            {
            }
            field("Alternative Item No."; "Alternative Item No.")
            {
            }
            field("Date Created"; "Date Created")
            {
                Visible = false;
            }
            field("Created by User ID"; "Created by User ID")
            {
                Visible = false;
            }
        }
        addafter("Last Date Modified")
        {
            field("Last Modified by User ID"; "Last Modified by User ID")
            {
                Visible = false;
            }
        }
        addafter("Sales Unit of Measure")
        {
            field("Alt. Sales Unit of Measure"; "Alt. Sales Unit of Measure")
            {
                Visible = false;
            }
        }
        addafter("Purch. Unit of Measure")
        {
            field("Alt. Purch. Unit of Measure"; "Alt. Purch. Unit of Measure")
            {
                Visible = false;
            }
        }
        addafter("Item Tracking Code")
        {
            field("ABC Code"; "ABC Code")
            {
                Visible = false;
            }
            field(Oversize; Oversize)
            {
                Visible = false;
            }
            field("Sales Order Multiple"; "Sales Order Multiple")
            {
                BlankZero = true;
                Visible = false;
            }
            field("Sorting Order"; "Sorting Order")
            {
                Visible = false;
            }
            field("SupplyHouse.com"; "SupplyHouse.com")
            {
                Visible = false;
            }
            field("Qty. on Purch. Order"; "Qty. on Purch. Order")
            {
                Visible = false;
            }
            field(Inventory; Inventory)
            {
                ToolTip = 'All inventory including on water and stocking rep';
            }
            field("Item UPC/EAN Number"; "Item UPC/EAN Number")
            {
            }
            field("Low Unit Price"; "Low Unit Price")
            {
            }
            field("Medium Unit Price"; "Medium Unit Price")
            {
            }
            field("High Unit Price"; "High Unit Price")
            {
            }
            field("Label Description"; "Label Description")
            {
                Visible = false;
            }
            field("Visible in Webshop"; "Visible in Webshop")
            {
                Visible = false;
            }
            field("WebShop Item Category Code"; "WebShop Item Category Code")
            {
                Visible = false;
            }
            field("IMAP Price"; "IMAP Price")
            {
            }
            field("MSRP Price"; "MSRP Price")
            {
            }
            field("Replacement Cost"; "Replacement Cost")
            {
            }
            field("Replacement Cost Date"; "Replacement Cost Date")
            {
            }
            field("Long Term Product Title"; "Long Term Product Title")
            {
            }
            field("Short Term Product Title"; "Short Term Product Title")
            {
            }
        }

    }
    actions
    {
        modify(Item)
        {
            CaptionML = ENU = 'Master Data', ESM = 'Datos maestros', FRC = 'DonnÙes principales', ENC = 'Master Data';

            //Unsupported feature: Change Name on "Item(Action 64)". Please convert manually.

        }
        modify("&Units of Measure")
        {
            CaptionML = ENU = '&Units of Measure', ESM = '&Unidades medida', FRC = '&UnitÙs de mesure', ENC = '&Units of Measure';

            //Unsupported feature: Change Visible on ""&Units of Measure"(Action 25)". Please convert manually.

        }

        modify("E&xtended Texts")
        {
            CaptionML = ENU = 'E&xtended Text', ESM = 'Te&xtos adicionales', FRC = 'Te&xtes Ùtendus', ENC = 'E&xtended Text';

            //Unsupported feature: Change Visible on ""E&xtended Text"(Action 28)". Please convert manually.

        }
        modify(DimensionsMultiple)
        {

            //Unsupported feature: Change Name on "DimensionsMultiple(Action 93)". Please convert manually.

            CaptionML = ENU = 'Dimensions-&Multiple', ESM = 'Dimensiones-&MÙltiple', FRC = 'Dimensions - &Multiples', ENC = 'Dimensions-&Multiple';

            //Unsupported feature: Change Visible on "DimensionsMultiple(Action 93)". Please convert manually.

        }
        modify("E&ntries")
        {
            CaptionML = ENU = 'E&ntries', ESM = '&Movimientos', FRC = 'Ù&critures', ENC = 'E&ntries';
        }
        modify("Ledger E&ntries")
        {
            CaptionML = ENU = 'Ledger E&ntries', ESM = '&Movimientos', FRC = 'Ù&critures comptables', ENC = 'Ledger E&ntries';



        }
        modify("&Phys. Inventory Ledger Entries")
        {
            CaptionML = ENU = '&Phys. Inventory Ledger Entries', ESM = 'Movs. inventario fÙ&sico', FRC = 'Ùcritures du grand livre de l''inventaire physique', ENC = '&Phys. Inventory Ledger Entries';

            //Unsupported feature: Change Visible on ""&Phys. Inventory Ledger Entries"(Action 23)". Please convert manually.

        }
        modify("Prices_Prices")
        {

            //Unsupported feature: Change Level on ""Prices_Prices"(Action 1901240604)". Please convert manually.


            //Unsupported feature: Change Name on ""Prices_Prices"(Action 1901240604)". Please convert manually.

            CaptionML = ENU = 'Sales Prices', ESM = 'Precios de venta', FRC = 'Prix de vente', ENC = 'Sales Prices';

            //Unsupported feature: Change Image on ""Prices_Prices"(Action 1901240604)". Please convert manually.

            PromotedCategory = Process;
            Promoted = true;

            //Unsupported feature: Change Visible on ""Prices_Prices"(Action 1901240604)". Please convert manually.

        }
        modify("Prices_LineDiscounts")
        {

            //Unsupported feature: Change Level on ""Prices_LineDiscounts"(Action 1900869004)". Please convert manually.


            //Unsupported feature: Change Name on ""Prices_LineDiscounts"(Action 1900869004)". Please convert manually.

            CaptionML = ENU = 'Sales Line Multipliers', ESM = 'Descuentos lÙnea de ventas', FRC = 'Escomptes de ligne de vente', ENC = 'Sales Line Discounts';

            //Unsupported feature: Change Image on ""Prices_LineDiscounts"(Action 1900869004)". Please convert manually.

            Promoted = false;

            //Unsupported feature: Change Visible on ""Prices_LineDiscounts"(Action 1900869004)". Please convert manually.

        }
        modify("Adjust Cost - Item Entries")
        {

            //Unsupported feature: Change Level on ""Adjust Cost - Item Entries"(Action 1907108104)". Please convert manually.

            CaptionML = ENU = 'Adjust Cost - Item Entries', ESM = 'Valorar existencias - movs. producto', FRC = 'Articles - Ajuster les coÙts', ENC = 'Adjust Cost - Item Entries';
            PromotedCategory = Process;
            Promoted = true;

            //Unsupported feature: Change Visible on ""Adjust Cost - Item Entries"(Action 1907108104)". Please convert manually.

        }
        modify(ManageApprovalWorkflow)
        {

            //Unsupported feature: Change Name on "ManageApprovalWorkflow(Action 20)". Please convert manually.

            CaptionML = ENU = '&Picture', ESM = 'Ima&gen', FRC = '&Image', ENC = '&Picture';

            //Unsupported feature: Change Image on "ManageApprovalWorkflow(Action 20)". Please convert manually.


            //Unsupported feature: Change RunObject on "ManageApprovalWorkflow(Action 20)". Please convert manually.


            //Unsupported feature: Change RunPageLink on "ManageApprovalWorkflow(Action 20)". Please convert manually.


            //Unsupported feature: Change Visible on "ManageApprovalWorkflow(Action 20)". Please convert manually.

        }
        modify("Requisition Worksheet")
        {
            CaptionML = ENU = 'Requisition Worksheet', ESM = 'Hoja de demanda', FRC = 'Feuille de rÙquisition', ENC = 'Requisition Worksheet';
            Promoted = true;

            //Unsupported feature: Change Visible on ""Requisition Worksheet"(Action 1905370404)". Please convert manually.

            PromotedCategory = Process;
        }

        modify("Item Reclassification Journal")
        {
            CaptionML = ENU = 'Item Reclassification Journal', ESM = 'Diario reclasificaciÙn producto', FRC = 'Journal de reclassements d''articles', ENC = 'Item Reclassification Journal';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Item Reclassification Journal"(Action 1906716204)". Please convert manually.

        }
        modify("Item Tracing")
        {
            CaptionML = ENU = 'Item Tracing', ESM = 'Seguim. prod.', FRC = 'RepÙrage d''article', ENC = 'Item Tracing';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Item Tracing"(Action 1902532604)". Please convert manually.

        }
        modify("Adjust Item Cost/Price")
        {
            CaptionML = ENU = 'Adjust Item Cost/Price', ESM = 'Modificar precios/costos de productos', FRC = 'Ajuster coÙt et prix article', ENC = 'Adjust Item Cost/Price';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Adjust Item Cost/Price"(Action 1900805004)". Please convert manually.

        }

        modify("Where-Used (Top Level)")
        {

            //Unsupported feature: Change Level on ""Where-Used (Top Level)"(Action 1902353206)". Please convert manually.

            CaptionML = ENU = 'Where Used (Top Level)', ESM = 'Puntos de uso (nivel superior)', FRC = 'Cas d''emploi (multi-niveau)', ENC = 'Where Used (Top Level)';

            //Unsupported feature: Change Name on ""Where-Used (Top Level)"(Action 1902353206)". Please convert manually.

            Promoted = false;

            //Unsupported feature: Change Visible on ""Where-Used (Top Level)"(Action 1902353206)". Please convert manually.

        }
        modify("Quantity Explosion of BOM")
        {

            //Unsupported feature: Change Level on ""Quantity Explosion of BOM"(Action 1907778006)". Please convert manually.

            CaptionML = ENU = 'Quantity Explosion of BOM', ESM = 'Despliegue cantidad en L.M.', FRC = 'Explosion de la quantitÙ de nomenclature', ENC = 'Quantity Explosion of BOM';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Quantity Explosion of BOM"(Action 1907778006)". Please convert manually.

        }
        modify("Issue History")
        {

            //Unsupported feature: Change Level on ""Issue History"(Action 1905655706)". Please convert manually.

            CaptionML = ENU = 'Issue History', ESM = 'Emitir historial', FRC = 'Ùmettre l''historique', ENC = 'Issue History';

            //Unsupported feature: Change Visible on ""Issue History"(Action 1905655706)". Please convert manually.

        }
        modify("Inventory Valuation - WIP")
        {

            //Unsupported feature: Change Level on ""Inventory Valuation - WIP"(Action 1907928706)". Please convert manually.

            CaptionML = ENU = 'Inventory Valuation - WIP', ESM = 'ValuaciÙn de inventarios - WIP', FRC = 'Ùvaluation de l''inventaire d''en-cours', ENC = 'Inventory Valuation - WIP';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Inventory Valuation - WIP"(Action 1907928706)". Please convert manually.

        }
        modify("Cost Shares Breakdown")
        {

            //Unsupported feature: Change Level on ""Cost Shares Breakdown"(Action 1905889606)". Please convert manually.

            CaptionML = ENU = 'Cost Shares Breakdown', ESM = 'AnÙlisis partes costos', FRC = 'Ventilation des partages de coÙts', ENC = 'Cost Shares Breakdown';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Cost Shares Breakdown"(Action 1905889606)". Please convert manually.

        }
        modify("Detailed Calculation")
        {

            //Unsupported feature: Change Level on ""Detailed Calculation"(Action 1901374406)". Please convert manually.

            CaptionML = ENU = 'Detailed Calculation', ESM = 'CÙlculo detallado', FRC = 'Calcul dÙtaillÙ', ENC = 'Detailed Calculation';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Detailed Calculation"(Action 1901374406)". Please convert manually.

        }
        modify("Rolled-up Cost Shares")
        {

            //Unsupported feature: Change Level on ""Rolled-up Cost Shares"(Action 1900812706)". Please convert manually.

            CaptionML = ENU = 'Rolled-up Cost Shares', ESM = 'Parte costos distrib.', FRC = 'CoÙt actions d''ensemble', ENC = 'Rolled-up Cost Shares';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Rolled-up Cost Shares"(Action 1900812706)". Please convert manually.

        }
        modify("Single-Level Cost Shares")
        {

            //Unsupported feature: Change Level on ""Single-Level Cost Shares"(Action 1901316306)". Please convert manually.

            CaptionML = ENU = 'Single-Level Cost Shares', ESM = 'Parte costos a un nivel', FRC = 'CoÙt actions Ù niveau unique', ENC = 'Single-Level Cost Shares';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Single-Level Cost Shares"(Action 1901316306)". Please convert manually.

        }
        modify("Inventory - List")
        {

            //Unsupported feature: Change Level on ""Inventory - List"(Action 1900907306)". Please convert manually.

            Promoted = false;

            //Unsupported feature: Change Visible on ""Inventory - List"(Action 1900907306)". Please convert manually.

        }
        modify("Item/Vendor Catalog")
        {

            //Unsupported feature: Change Level on ""Item/Vendor Catalog"(Action 1900430206)". Please convert manually.

            Promoted = false;

            //Unsupported feature: Change Visible on ""Item/Vendor Catalog"(Action 1900430206)". Please convert manually.

        }
        modify("Phys. Inventory List")
        {

            //Unsupported feature: Change Level on ""Phys. Inventory List"(Action 1907644006)". Please convert manually.

            CaptionML = ENU = 'Phys. Inventory List', ESM = 'Lista inventario fÙsico', FRC = 'Liste de l''inventaire physique', ENC = 'Phys. Inventory List';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Phys. Inventory List"(Action 1907644006)". Please convert manually.

        }

        modify("Inventory Cost and Price List")
        {

            //Unsupported feature: Change Level on ""Inventory Cost and Price List"(Action 1900128906)". Please convert manually.

            CaptionML = ENU = 'Inventory Cost and Price List', ESM = 'Lista de precios y costos', FRC = 'CoÙt de l''inventaire et liste de prix', ENC = 'Inventory Cost and Price List';
            Promoted = true;

            //Unsupported feature: Change Visible on ""Inventory Cost and Price List"(Action 1900128906)". Please convert manually.

            PromotedCategory = Report;
        }
        modify("Inventory Availability")
        {

            //Unsupported feature: Change Level on ""Inventory Availability"(Action 1901091106)". Please convert manually.

            CaptionML = ENU = 'Inventory Availability', ESM = 'Disponibilidad existencias', FRC = 'DisponibilitÙ de l''inventaire', ENC = 'Inventory Availability';
            Promoted = true;

            //Unsupported feature: Change Visible on ""Inventory Availability"(Action 1901091106)". Please convert manually.

            PromotedCategory = Report;
        }
        modify("Item Register - Quantity")
        {

            //Unsupported feature: Change Level on ""Item Register - Quantity"(Action 1907629906)". Please convert manually.

            CaptionML = ENU = 'Item Register - Quantity', ESM = 'Registro prod. - cdad.', FRC = 'Registre d''articles - QuantitÙ', ENC = 'Item Register - Quantity';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Item Register - Quantity"(Action 1907629906)". Please convert manually.

        }
        modify("Item Register - Value")
        {

            //Unsupported feature: Change Level on ""Item Register - Value"(Action 1902962906)". Please convert manually.

            Promoted = false;

            //Unsupported feature: Change Visible on ""Item Register - Value"(Action 1902962906)". Please convert manually.

        }
        modify("Inventory - Cost Variance")
        {

            //Unsupported feature: Change Level on ""Inventory - Cost Variance"(Action 1900730006)". Please convert manually.

            CaptionML = ENU = 'Inventory - Cost Variance', ESM = 'Existencias - VariaciÙn del costo', FRC = 'Inventaire : Ùvolution des coÙts', ENC = 'Inventory - Cost Variance';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Inventory - Cost Variance"(Action 1900730006)". Please convert manually.

        }
        modify("Invt. Valuation - Cost Spec.")
        {

            //Unsupported feature: Change Level on ""Invt. Valuation - Cost Spec."(Action 1904299906)". Please convert manually.

            CaptionML = ENU = 'Invt. Valuation - Cost Spec.', ESM = 'Valorac. exist.-especif. costo', FRC = 'Ùvaluation des stocks - SpÙcification coÙt', ENC = 'Invt. Valuation - Cost Spec.';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Invt. Valuation - Cost Spec."(Action 1904299906)". Please convert manually.

        }
        modify("Compare List")
        {

            //Unsupported feature: Change Level on ""Compare List"(Action 1907846806)". Please convert manually.

            CaptionML = ENU = 'Compare List', ESM = 'Lista comparaciÙn', FRC = 'Liste de comparaison', ENC = 'Compare List';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Compare List"(Action 1907846806)". Please convert manually.

        }
        modify("Inventory - Transaction Detail")
        {

            //Unsupported feature: Change Level on ""Inventory - Transaction Detail"(Action 1904068306)". Please convert manually.

            CaptionML = ENU = 'Inventory - Transaction Detail', ESM = 'Existencias - Movimientos', FRC = 'Inventaire - DÙtail de transaction', ENC = 'Inventory - Transaction Detail';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Inventory - Transaction Detail"(Action 1904068306)". Please convert manually.

        }
        modify("Item Charges - Specification")
        {

            //Unsupported feature: Change Level on ""Item Charges - Specification"(Action 1900461506)". Please convert manually.

            CaptionML = ENU = 'Item Charges - Specification', ESM = 'Cargos prod. - especificaciÙn', FRC = 'Frais annexes - SpÙcification', ENC = 'Item Charges - Specification';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Item Charges - Specification"(Action 1900461506)". Please convert manually.

        }

        modify("Availability Projection")
        {

            //Unsupported feature: Change Level on ""Availability Projection"(Action 1903023706)". Please convert manually.

            CaptionML = ENU = 'Availability Projection', ESM = 'ProyecciÙn disponib.', FRC = 'PrÙvision de la disponibilitÙ', ENC = 'Availability Projection';

            //Unsupported feature: Change Visible on ""Availability Projection"(Action 1903023706)". Please convert manually.

        }
        modify("Item Turnover")
        {

            //Unsupported feature: Change Level on ""Item Turnover"(Action 1900830806)". Please convert manually.

            CaptionML = ENU = 'Item Turnover', ESM = 'AnÙlisis producto', FRC = 'Rotation d''articles', ENC = 'Item Turnover';

            //Unsupported feature: Change Visible on ""Item Turnover"(Action 1900830806)". Please convert manually.

        }
        modify("Item Expiration - Quantity")
        {

            //Unsupported feature: Change Level on ""Item Expiration - Quantity"(Action 1906747006)". Please convert manually.

            CaptionML = ENU = 'Item Expiration - Quantity', ESM = 'Caducidad producto - Cantidad', FRC = 'Expiration d''article - QuantitÙ', ENC = 'Item Expiration - Quantity';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Item Expiration - Quantity"(Action 1906747006)". Please convert manually.

        }

        modify("Inventory - Customer Sales")
        {

            //Unsupported feature: Change Level on ""Inventory - Customer Sales"(Action 1904034006)". Please convert manually.

            Promoted = false;

            //Unsupported feature: Change Visible on ""Inventory - Customer Sales"(Action 1904034006)". Please convert manually.

        }
        modify("Inventory - Top 10 List")
        {

            //Unsupported feature: Change Level on ""Inventory - Top 10 List"(Action 1907930606)". Please convert manually.

            Promoted = false;

            //Unsupported feature: Change Visible on ""Inventory - Top 10 List"(Action 1907930606)". Please convert manually.

        }

        modify("Item Age Composition - Value")
        {

            //Unsupported feature: Change Level on ""Item Age Composition - Value"(Action 1903496006)". Please convert manually.

            CaptionML = ENU = 'Item Age Composition - Value', ESM = 'ComposiciÙn antig. prod.-valor', FRC = 'AnciennetÙ d''article - Valeur', ENC = 'Item Age Composition - Value';
            Promoted = false;

            //Unsupported feature: Change Visible on ""Item Age Composition - Value"(Action 1903496006)". Please convert manually.

        }
        modify("Inventory Valuation")
        {

            //Unsupported feature: Change Level on ""Inventory Valuation"(Action 1906316306)". Please convert manually.

            CaptionML = ENU = 'Inventory Valuation', ESM = 'ValuaciÙn de inventarios', FRC = 'Ùvaluation de l''inventaire', ENC = 'Inventory Valuation';
            Promoted = true;

            //Unsupported feature: Change Visible on ""Inventory Valuation"(Action 1906316306)". Please convert manually.

            PromotedCategory = Report;
        }
        modify("Inventory Purchase Orders")
        {

            //Unsupported feature: Change Level on ""Inventory Purchase Orders"(Action 1904739806)". Please convert manually.

            Promoted = false;

            //Unsupported feature: Change Visible on ""Inventory Purchase Orders"(Action 1904739806)". Please convert manually.

        }
        modify("Inventory - Vendor Purchases")
        {

            //Unsupported feature: Change Level on ""Inventory - Vendor Purchases"(Action 1906231806)". Please convert manually.

            Promoted = false;

            //Unsupported feature: Change Visible on ""Inventory - Vendor Purchases"(Action 1906231806)". Please convert manually.

        }
        modify("Inventory - Reorders")
        {

            //Unsupported feature: Change Level on ""Inventory - Reorders"(Action 1906101206)". Please convert manually.

            CaptionML = ENU = 'Inventory - Reorders', ESM = 'Producto - Reorden', FRC = 'Inventaire - RÙapprovisionnement', ENC = 'Inventory - Reorders';

            //Unsupported feature: Change Visible on ""Inventory - Reorders"(Action 1906101206)". Please convert manually.

        }
        modify("Inventory - Sales Back Orders")
        {

            //Unsupported feature: Change Level on ""Inventory - Sales Back Orders"(Action 1900210306)". Please convert manually.

            CaptionML = ENU = 'Inventory - Sales Back Orders', ESM = 'Productos - Pedidos por servir', FRC = 'Inventaire - Commandes en retard', ENC = 'Inventory - Sales Back Orders';

            //Unsupported feature: Change Visible on ""Inventory - Sales Back Orders"(Action 1900210306)". Please convert manually.

        }
        modify("Sales Order Status")
        {

            //Unsupported feature: Change Level on ""Sales Order Status"(Action 1906608106)". Please convert manually.

            CaptionML = ENU = 'Sales Order Status', ESM = 'Estado pedido venta', FRC = 'Ùtat du document de vente', ENC = 'Sales Order Status';

            //Unsupported feature: Change Visible on ""Sales Order Status"(Action 1906608106)". Please convert manually.

        }

        modify(Availability)
        {
            CaptionML = ENU = 'Availability', ESM = 'Disponibilidad', FRC = 'DisponibilitÙ', ENC = 'Availability';
        }
        modify("Items b&y Location")
        {
            CaptionML = ENU = 'Items b&y Location', ESM = 'Prods. por &almacÙn', FRC = 'Articles &par emplacement', ENC = 'Items b&y Location';

            //Unsupported feature: Change Visible on ""Items b&y Location"(Action 73)". Please convert manually.

        }
        modify("&Item Availability by")
        {
            CaptionML = ENU = '&Item Availability by', ESM = '&Disponibilidad prod. por', FRC = 'DisponibilitÙ d''&article par', ENC = '&Item Availability by';
        }
        modify("<Action5>")
        {
            CaptionML = ENU = 'Event', ESM = 'Evento', FRC = 'ÙvÙnement', ENC = 'Event';

            //Unsupported feature: Change Visible on ""<Action5>"(Action 5)". Please convert manually.

        }
        modify(Period)
        {
            CaptionML = ENU = 'Period', ESM = 'Periodo', FRC = 'PÙriode', ENC = 'Period';

            //Unsupported feature: Change Visible on "Period(Action 21)". Please convert manually.

        }

        modify(Location)
        {
            CaptionML = ENU = 'Location', ESM = 'AlmacÙn', FRC = 'Emplacement', ENC = 'Location';

            //Unsupported feature: Change Visible on "Location(Action 78)". Please convert manually.

        }


        modify("Assembly/Production")
        {
            CaptionML = ENU = 'Assembly', ESM = 'Ensamblado/producciÙn', FRC = 'Assemblage/Production', ENC = 'Assembly/Production';
        }

        modify("Cost Shares")
        {
            CaptionML = ENU = 'Cost Shares', ESM = 'Partes costos', FRC = 'CoÙts totaux', ENC = 'Cost Shares';

            //Unsupported feature: Change Visible on ""Cost Shares"(Action 50)". Please convert manually.

        }

        modify("Calc. Stan&dard Cost")
        {
            CaptionML = ENU = 'Calc. Stan&dard Cost', ESM = 'Calcular costo estÙn&dar', FRC = 'Calculer coÙt stan&dard', ENC = 'Calc. Stan&dard Cost';

            //Unsupported feature: Change Visible on ""Calc. Stan&dard Cost"(Action 46)". Please convert manually.

        }

        modify(Production)
        {
            CaptionML = ENU = 'Production', ESM = 'ProducciÙn', FRC = 'Fabrication', ENC = 'Production';

            //Unsupported feature: Change Visible on "Production(Action 41)". Please convert manually.

        }
        modify("Production BOM")
        {
            CaptionML = ENU = 'Production BOM', ESM = 'L.M. producciÙn', FRC = 'Nomenclature de production', ENC = 'Production BOM';

            //Unsupported feature: Change RunPageLink on ""Production BOM"(Action 32)". Please convert manually.


            //Unsupported feature: Change Visible on ""Production BOM"(Action 32)". Please convert manually.

        }
        modify(Action24)
        {
            CaptionML = ENU = 'Calc. Stan&dard Cost', ESM = 'Calcular costo estÙn&dar', FRC = 'Calculer coÙt stan&dard', ENC = 'Calc. Stan&dard Cost';

            //Unsupported feature: Change Visible on "Action24(Action 24)". Please convert manually.

        }
        modify("&Reservation Entries")
        {
            CaptionML = ENU = '&Reservation Entries', ESM = 'Movs. &reserva', FRC = 'Ùcritures &rÙservation', ENC = '&Reservation Entries';

            //Unsupported feature: Change Visible on ""&Reservation Entries"(Action 77)". Please convert manually.

        }
        modify("&Value Entries")
        {
            CaptionML = ENU = '&Value Entries', ESM = 'Movs. &valor', FRC = 'Ùcritures &valeur', ENC = '&Value Entries';

            //Unsupported feature: Change Visible on ""&Value Entries"(Action 5800)". Please convert manually.

        }
        modify("Item &Tracking Entries")
        {
            CaptionML = ENU = 'Item &Tracking Entries', ESM = 'Movs. &seguim. prod.', FRC = 'Ùcritures de &traÙabilitÙ', ENC = 'Item &Tracking Entries';

            //Unsupported feature: Change Visible on ""Item &Tracking Entries"(Action 6500)". Please convert manually.

        }
        modify("&Warehouse Entries")
        {
            CaptionML = ENU = '&Warehouse Entries', ESM = 'Movs. &almacÙn', FRC = 'Ù&critures d''entrepÙt', ENC = '&Warehouse Entries';

            //Unsupported feature: Change Visible on ""&Warehouse Entries"(Action 7)". Please convert manually.

        }
        modify(Statistics)
        {
            CaptionML = ENU = 'Statistics', ESM = 'EstadÙsticas', FRC = 'Statistiques', ENC = 'Statistics';
        }
        modify(Action16)
        {
            CaptionML = ENU = 'Statistics', ESM = 'EstadÙsticas', FRC = 'Statistiques', ENC = 'Statistics';
            Promoted = true;

            //Unsupported feature: Change Visible on "Action16(Action 16)". Please convert manually.

            PromotedCategory = Process;
        }
        modify("Entry Statistics")
        {
            CaptionML = ENU = 'Entry Statistics', ESM = 'EstadÙsticas documentos', FRC = 'Statistiques Ùcritures', ENC = 'Entry Statistics';

            //Unsupported feature: Change Visible on ""Entry Statistics"(Action 17)". Please convert manually.

        }
        modify("T&urnover")
        {
            CaptionML = ENU = 'T&urnover', ESM = 'AnÙ&lisis', FRC = 'Ro&ulement', ENC = 'T&urnover';

            //Unsupported feature: Change Visible on ""T&urnover"(Action 22)". Please convert manually.

        }

        modify("Sales_LineDiscounts")
        {

            //Unsupported feature: Change Name on ""Sales_LineDiscounts"(Action 34)". Please convert manually.

            CaptionML = ENU = 'Multipliers', ESM = 'Descuentos lÙnea', FRC = 'Ligne Escomptes', ENC = 'Line Discounts';

            //Unsupported feature: Change Visible on ""Sales_LineDiscounts"(Action 34)". Please convert manually.

        }
        modify("Prepa&yment Percentages")
        {
            CaptionML = ENU = 'Prepa&yment Percentages', ESM = 'Porcentajes &anticipo', FRC = 'Pour&centages paiement anticipÙ', ENC = 'Prepa&yment Percentages';

            //Unsupported feature: Change Visible on ""Prepa&yment Percentages"(Action 124)". Please convert manually.

        }
        modify("Line Discounts")
        {
            CaptionML = ENU = 'Line Discounts', ESM = 'Descuentos lÙnea', FRC = 'Ligne Escomptes', ENC = 'Line Discounts';

            //Unsupported feature: Change Visible on ""Line Discounts"(Action 42)". Please convert manually.

        }
        modify(Action125)
        {
            CaptionML = ENU = 'Prepa&yment Percentages', ESM = 'Porcentajes &anticipo', FRC = 'Pour&centages paiement anticipÙ', ENC = 'Prepa&yment Percentages';

            //Unsupported feature: Change Visible on "Action125(Action 125)". Please convert manually.

        }


        modify(PurchPricesDiscountsOverview)
        {

            //Unsupported feature: Change ActionType on "PurchPricesDiscountsOverview(Action 107)". Please convert manually.


            //Unsupported feature: Change Name on "PurchPricesDiscountsOverview(Action 107)". Please convert manually.

            CaptionML = ENU = 'R&esource', ESM = '&Recurso', FRC = 'Re&ssource', ENC = 'R&esource';

            //Unsupported feature: Change Image on "PurchPricesDiscountsOverview(Action 107)". Please convert manually.


            //Unsupported feature: Change Visible on "PurchPricesDiscountsOverview(Action 107)". Please convert manually.

        }
        modify(Warehouse)
        {
            CaptionML = ENU = 'Warehouse', ESM = 'AlmacÙn', FRC = 'EntrepÙt', ENC = 'Warehouse';
        }
        modify("&Bin Contents")
        {
            CaptionML = ENU = '&Bin Contents', ESM = 'Contenidos u&bicaciÙn', FRC = 'C&ontenu de la zone', ENC = '&Bin Contents';

        }
        modify("Stockkeepin&g Units")
        {
            CaptionML = ENU = 'Stockkeepin&g Units', ESM = '&Uds. de almacenam.', FRC = 'UnitÙs de stoc&k', ENC = 'Stockkeepin&g Units';


        }

        modify(Troubleshooting)
        {
            CaptionML = ENU = 'Troubleshooting', ESM = 'SoluciÙn de problemas', FRC = 'DÙpannage', ENC = 'Troubleshooting';

        }
        modify("Troubleshooting Setup")
        {
            CaptionML = ENU = 'Troubleshooting Setup', ESM = 'Config. detecciÙn errores', FRC = 'Configuration dÙpannage', ENC = 'Troubleshooting Setup';

        }


        modify("Resource &Skills")
        {

            CaptionML = ENU = 'Resource &Skills', ESM = '&Cualificaciones', FRC = '&CompÙtences de la ressource', ENC = 'Resource &Skills';

        }
        modify("Skilled R&esources")
        {
            CaptionML = ENU = 'Skilled R&esources', ESM = '&Recursos calificados', FRC = '&Ressources compÙtentes', ENC = 'Skilled R&esources';

        }

        modify(AdjustInventory)
        {
            Visible = false;
        }


        modify(PricesandDiscounts)
        {
            Visible = false;
        }


        modify(PricesDiscountsOverview)
        {
            Visible = false;
        }
        modify("Sales Price Worksheet")
        {
            Visible = false;
        }
        modify(PeriodicActivities)
        {
            Visible = false;
        }

        modify("Post Inventory Cost to G/L")
        {
            Visible = false;
        }
        modify("Physical Inventory Journal")
        {
            Visible = false;
        }
        modify("Revaluation Journal")
        {
            Visible = false;
        }
        modify(RequestApproval)
        {
            Visible = false;
        }
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }
        modify(Workflow)
        {
            Visible = false;
        }
        modify(CreateApprovalWorkflow)
        {
            Visible = false;
        }


        modify(ApplyTemplate)
        {
            Visible = false;
        }
        modify(Display)
        {
            Visible = false;
        }
        modify(ReportFactBoxVisibility)
        {
            Visible = false;
        }

        modify(Costing)
        {
            Visible = false;
        }

        modify("Item Substitutions")
        {
            Visible = false;
        }

        //Unsupported feature: PropertyDeletion on ""Price List"(Action 1905572506)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Price List"(Action 1905572506)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Price List"(Action 1905572506)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Inventory Cost and Price List"(Action 1900128906)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Inventory Availability"(Action 1901091106)". Please convert manually.

        modify("Item Register")
        {
            Visible = false;
        }

        modify("Inventory Details")
        {
            Visible = false;
        }

        //Unsupported feature: PropertyDeletion on ""Item Age Composition - Qty."(Action 1900111206)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Item Age Composition - Qty."(Action 1900111206)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Item Turnover"(Action 1900830806)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Item Turnover"(Action 1900830806)". Please convert manually.

        modify(Reports)
        {
            Visible = false;
        }

        //Unsupported feature: PropertyDeletion on ""Inventory - Customer Sales"(Action 1904034006)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Inventory - Customer Sales"(Action 1904034006)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Inventory - Top 10 List"(Action 1907930606)". Please convert manually.

        modify("Finance Reports")
        {
            Visible = false;
        }

        //Unsupported feature: PropertyDeletion on ""Item Age Composition - Value"(Action 1903496006)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Inventory Valuation"(Action 1906316306)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Inventory Valuation"(Action 1906316306)". Please convert manually.

        modify(Orders)
        {
            Visible = false;
        }

        //Unsupported feature: PropertyDeletion on ""Sales Order Status"(Action 1906608106)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Sales Order Status"(Action 1906608106)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Back Order Fill by Item"(Action 1904202206)". Please convert manually.



        modify(ApprovalEntries)
        {
            Visible = false;
        }



        modify(ActionGroupCRM)
        {
            Visible = false;
        }
        modify(CRMGoToProduct)
        {
            Visible = false;
        }
        modify(CRMSynchronizeNow)
        {
            Visible = false;
        }
        modify(Coupling)
        {
            Visible = false;
        }
        modify(ManageCRMCoupling)
        {
            Visible = false;
        }
        modify(DeleteCRMCoupling)
        {
            Visible = false;
        }

        //Unsupported feature: PropertyDeletion on ""Calc. Stan&dard Cost"(Action 46)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Calc. Unit Price"(Action 44)". Please convert manually.


        //Unsupported feature: PropertyDeletion on "Action29(Action 29)". Please convert manually.


        //Unsupported feature: PropertyDeletion on "Action24(Action 24)". Please convert manually.


        //Unsupported feature: PropertyDeletion on "Action40(Action 40)". Please convert manually.


        //Unsupported feature: PropertyDeletion on ""Nonstoc&k Items"(Action 76)". Please convert manually.

        modify(PurchPricesandDiscounts)
        {
            Visible = false;
        }
        modify("Set Special Prices")
        {
            Visible = false;
        }
        modify("Set Special Discounts")
        {
            Visible = false;
        }

        addfirst(Availability)
        {
            action(CustAvailPrice)
            {
                Caption = 'Cust. Avail. & Price';
                Image = ItemCosts;

                trigger OnAction();
                begin
                    //TOP100B KT ABCSI Item Cust. Avail. & Price 03192015
                    /*CLEAR(ItemCustAvailPage);
                    ItemCustAvailPage.SetRecords(Rec,CustRec,TRUE);
                    ItemCustAvailPage.UpdateQuantities;
                    ItemCustAvailPage.ACTIVATE;
                    ItemCustAvailPage.RUN;*/
                    //TOP100B KT ABCSI Item Cust. Avail. & Price 03192015

                end;
            }
        }
        addafter("Va&riants")
        {


        }
        addafter(Identifiers)
        {
            action("Barcode Conversion")
            {
                Caption = 'Barcode Conversion';
                // RunObject = Page "Barcode Conversions";//TODO:
                //RunPageLink = Type = CONST(Item),
                //"Item No." = FIELD("No.");//TODO:
            }
            action("Customer Package UOM")
            {
                Caption = 'Customer Package UOM';
                //RunObject = Page "Customer Package Unit of Meas.";//TODO:
                //RunPageLink = "Item No." = FIELD("No.");//TODO:
            }
            group("Forecasting && &Procurement")
            {
                Caption = 'Forecasting && &Procurement';
                Image = Purchasing;
                action("&Procurement Units")
                {
                    Caption = '&Procurement Units';
                    Image = BankAccountRec;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    //RunObject = Page "Procurement Unit List";//TODO:
                    //RunPageLink = "Item No." = FIELD("No.");//todo:
                    //RunPageView = SORTING("Item No.", "Variant Code", "Location Code")//todo:
                    //ORDER(Ascending);//todo:
                }
                action("Procurement Unit &Edit")
                {
                    Caption = 'Procurement Unit &Edit';
                    /*//TODO:
                    RunObject = Page "Procurement Unit Edit";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.", "Variant Code", "Location Code")
                                  ORDER(Ascending);
                                  *///TODO:
                }
            }
        }
        addafter("Co&mments")
        {


            action("Change Log Entries")
            {
                Caption = 'Change Log Entries';
                trigger OnAction();
                var
                    ChangeLogEntry: Record "Change Log Entry";
                    ChangeLogMgt: Codeunit "Change Log Management";
                begin
                    //<TPZ1728>
                    //ChangeLogMgt.OpenSSRSReport(DATABASE::Item, "No.", '','');
                    //EXIT;
                    //</TPZ1728>

                    // <TPZ129>
                    //ChangeLogEntry.RESET;
                    //ChangeLogEntry.SETRANGE("Table No.",DATABASE::Item);
                    //ChangeLogEntry.SETRANGE("Primary Key Field 1 Value","No.");
                    //PAGE.RUNMODAL(PAGE::"Change Log Entries",ChangeLogEntry);
                    // </TPZ129>
                end;
            }
        }
        addafter("Sales_LineDiscounts")
        {
            action("Hot Sheet Prices")
            {
                Caption = 'Hot Sheet Prices';
                Image = Price;
                /*
                RunObject = Page "Hot Sheet Prices";
                RunPageLink = "Item No." = FIELD("No.");
                *///TODO:
            }
        }
        addafter("Prepa&yment Percentages")
        {
            action(Quotes)
            {
                CaptionML = ENU = 'Quotes',
                            ESM = 'Pedidos',
                            FRC = 'Commandes',
                            ENC = 'Quotes';
                Image = Quote;
                /*
                RunObject = Page "Sales Lines";
                RunPageLink = Type = CONST(Item),
                              "No." = FIELD("No.");*///TODO:

            }
        }
        addafter("Returns Orders")
        {
            group("E-Ship")
            {
                Caption = 'E-Ship';
                action("International Shipping")
                {
                    Caption = 'International Shipping';
                    /*
                    RunObject = Page "Item Int. Shipping Card";
                    RunPageLink = "No." = FIELD("No.");
                    *///TODO:
                }
                action("E-Ship Agent Options")
                {
                    Caption = 'E-Ship Agent Options';

                    trigger OnAction();
                    var
                    //Shipping: Codeunit Shipping;//TODO:
                    begin
                        //Shipping.ShowOptPageItemResource(DATABASE::Item, "No.");//TODO:
                    end;
                }
                action("Required Shipping Agents")
                {
                    Caption = 'Required Shipping Agents';
                    /*
                    RunObject = Page "Required Shipping Agents";
                    RunPageLink = Type = CONST(Item),
                                  Code = FIELD("No.");
                                  *///TODO:
                }
                action("E-Ship Hazardous Material Card")
                {
                    Caption = 'E-Ship Hazardous Material Card';
                    /*
                    RunObject = Page "SE Hazardous Material";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING(Type, "No.")
                                  ORDER(Ascending);
                                  *///TODO:
                }
            }
        }
        addafter(Action125)
        {
            action("Requisition Lines")
            {
                Caption = 'Requisition Lines';
                Image = Worksheet;
                RunObject = Page "Requisition Lines";
                RunPageLink = "No." = FIELD("No.");
                RunPageView = SORTING(Type, "No.")
                              WHERE(Type = CONST(Item));
            }
        }
        addafter("Adjust Item Cost/Price")
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions',
                            ESM = 'Acci&ones',
                            FRC = 'F&onctions',
                            ENC = 'F&unctions';
                Image = "Action";

            }
        }
        addfirst("Inventory Details")
        {
            action("Inventory History Details")
            {
                Caption = 'Inventory History Details';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                var
                    URL: Text[1000];
                //HttpUtility: DotNet "'System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Web.HttpUtility";//TODO:
                begin
                    /*// <TPZ135><TPZ2777>
                    URL :=
                      'http://nyvsvnavsql5/reportserver?/User%20Reports%20-%20Product/Inventory%20History%20Details&rs:Command=Render&ItemNo=' +
                      //<TPZ1583>
                      HttpUtility.UrlEncode("No.");
                      //</TPZ1583>
                    
                    HYPERLINK(URL);
                    // </TPZ135>
                    */

                end;
            }
            action(InvHistDetailsNoVirtualSales)
            {
                Caption = 'Inv. Hist. Details No Virtual Sales';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                var
                    URL: Text[1000];
                //HttpUtility: DotNet "'System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Web.HttpUtility";//TODO:
                begin
                    /*// <TPZ135><TPZ2777>
                    URL :=
                      'http://nyvsvnavsql5/reportserver?/User%20Reports%20-%20Product/Inventory%20History%20Details%20No%20Virtual%20Sales&rs:Command=Render&ItemNo=' +
                      //<TPZ1583>
                      HttpUtility.UrlEncode("No.");
                      //</TPZ1583>
                    
                    HYPERLINK(URL);
                    // </TPZ135>
                    */

                end;
            }
            action("Alt. UOM Inventory History Details")
            {
                Caption = 'Alt. UOM Inventory History Details';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                var
                    URL: Text[1000];
                //HttpUtility: DotNet "'System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Web.HttpUtility";//TODO:
                begin
                    /*// <TPZ135><TPZ2777>
                    URL :=
                      'http://nyvsvnavsql5/reportserver?/User%20Reports%20-%20Product/Inventory%20History%20Details&rs:Command=Render&ItemNo=' +
                      //<TPZ1583>
                      HttpUtility.UrlEncode("No.");
                      //</TPZ1583>
                    
                    URL :=
                      URL +
                      '&DisplayQtysInAltPurchUOM=True';
                    
                    HYPERLINK(URL);
                    // </TPZ135>
                    */

                end;
            }
            action(InvHistDetailsNoVirtualSalesAltUOM)
            {
                Caption = 'Alt. UOM Inv. Hist. Details No Virtual Sales';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                var
                    URL: Text[1000];
                //HttpUtility: DotNet "'System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Web.HttpUtility";//TODO:
                begin
                    /*// <TPZ135><TPZ2777>
                    URL :=
                      'http://nyvsvnavsql5/reportserver?/User%20Reports%20-%20Product/Inventory%20History%20Details%20No%20Virtual%20Sales&rs:Command=Render&ItemNo=' +
                      //<TPZ1583>
                      HttpUtility.UrlEncode("No.");
                      //</TPZ1583>
                    
                    URL :=
                      URL +
                      '&DisplayQtysInAltPurchUOM=True';
                    
                    HYPERLINK(URL);
                    // </TPZ135>
                    */

                end;
            }
        }
        addafter("Inventory - List")
        {
            action("Inventory - Sales Statistics")
            {
                CaptionML = ENU = 'Inventory - Sales Statistics',
                            ESM = 'Existencias - EstadÙsticas ventas',
                            FRC = 'Inventaire - Statistiques de ventes',
                            ENC = 'Inventory - Sales Statistics';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Sales Statistics";
            }
        }
        addafter("Inventory - List")
        {
            action(Action1908000106)
            {
                CaptionML = ENU = 'Item Charges - Specification',
                            ESM = 'Cargos prod. - especificaciÙn',
                            FRC = 'Frais annexes - SpÙcification',
                            ENC = 'Item Charges - Specification';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Item Charges - Specification";
            }
        }
        addafter("Inventory - List")
        {
            action("Item Label Description")
            {
                Caption = 'Item Label Description';
                Image = "Report";
                //RunObject = Report "Item Label Description";//TODO:
            }
            action("NAV Item Attribute")
            {
                Caption = 'NAV Item Attribute';
                // RunObject = Report "NAV Item Attribute";//TODO:
            }
        }

        moveafter("Va&riants"; Dimensions)
        moveafter("Substituti&ons"; "Cross Re&ferences")
        moveafter(Translations; ManageApprovalWorkflow)
        moveafter(Identifiers; "Assembly/Production")
        moveafter(Action24; History)
        moveafter("Ledger E&ntries"; "&Reservation Entries")
        moveafter("&Reservation Entries"; "&Phys. Inventory Ledger Entries")
        moveafter("&Phys. Inventory Ledger Entries"; "&Value Entries")
        moveafter(Resources; PurchPricesDiscountsOverview)
        moveafter(Resources; "Resource &Skills")
        moveafter("Phys. Inventory List"; "Price List")
        moveafter("Inventory Cost and Price List"; "Inventory - Top 10 List")
        moveafter("Inventory - Top 10 List"; "Where-Used (Top Level)")
        moveafter("Quantity Explosion of BOM"; "Compare List")
        moveafter("Compare List"; "Item Register - Quantity")
        moveafter("Item Register - Quantity"; "Inventory - Transaction Detail")
        moveafter("Inventory - Transaction Detail"; "Back Order Fill by Item")
        moveafter("Back Order Fill by Item"; "Issue History")
        moveafter("Issue History"; "Picking List by Item")
        moveafter("Picking List by Item"; "Purchase Advice")
        moveafter("Purchase Advice"; "Sales Order Status")
        moveafter("Sales Order Status"; "Inventory Purchase Orders")
        moveafter("Assemble to Order - Sales"; "Inventory - Customer Sales")
        moveafter("Inventory - Customer Sales"; "Inventory - Vendor Purchases")
        moveafter("Inventory - Cost Variance"; "Inventory Valuation")
        moveafter("Inventory Valuation"; "Invt. Valuation - Cost Spec.")
        moveafter("Inventory Valuation - WIP"; "Item Register - Value")
        moveafter("Item Register - Value"; "Item Charges - Specification")
        moveafter("Item Age Composition - Value"; "Item Expiration - Quantity")
        moveafter("Single-Level Cost Shares"; "Inventory to G/L Reconcile")
    }

    var
        MatrixRecord: Record Location;
        MatrixRecords: array[32] of Record Location;
        MATRIX_CaptionSet: array[32] of Text[1024];
        ShowInTransit: Boolean;
        MatrixRecordRef: RecordRef;
        ShowColumnName: Boolean;
        MATRIX_CaptionRange: Text[100];
        MATRIX_PKFirstRecInCurrSet: Text[100];
        MATRIX_CurrSetLength: Integer;
        MATRIX_SetWanted: Option Initial,Previous,Same,Next;
        "***ABCSI Globals***": Integer;
        //ItemCustAvailPage: Page "Item Cust. Avail. & Price";//TODO:
        CustRec: Record Customer;

        QtyAvailtoPick: Decimal;
    //WhseCreatePick: Codeunit "Whse. Create Pick";//TODO:
    //itemManagement: Codeunit "Item Management";//TODO:
    //Table14EventPublishers: Codeunit Table14EventPublishers;//TODO:

    //<TPZ2493>
    //QtyAvailtoPick := WhseCreatePick.QtyAvailtoPick("No.",GETFILTER("Location Filter"));//TODO:
    //CurrPage.ItemInventoryFactBox.PAGE.AssignQtyAvlbToPick(QtyAvailtoPick);//TODO:
    //</TPZ2493>
    //{=======} TARGET
    //end;


    //Unsupported feature: CodeModification on "OnOpenPage". Please convert manually.

    //trigger OnOpenPage();
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
    SetWorkflowManagementEnabledState;
    #4..6
    CurrPage."Power BI Report FactBox".PAGE.SetNameFilter(CurrPage.CAPTION);
    CurrPage."Power BI Report FactBox".PAGE.SetContext(CurrPage.OBJECTID(false));
    PowerBIVisible := SetPowerBIUserConfig.SetUserConfig(PowerBIUserConfiguration,CurrPage.OBJECTID(false));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //{=======} MODIFIED
    // <TPZ159>
    //SetSecurityFilterOnPriceBook;
    //SetSecurityFilterOnLocation;
    // </TPZ159>
    //{=======} TARGET
    #1..9
    {<<<<<<<}
    ;ESACC_EasySecurity(true);
    */
    //end;

    local procedure ESACC_EasySecurity(OpenObject: Boolean);
    var
        // SetFilters: Codeunit "ES FLADS Set Filters";//TODO:
        TempBoolean: Boolean;
    begin
        if OpenObject then begin
            //SetFilters.Filter27(Rec, 8, 31);//TODO:

            TempBoolean := CurrPage.EDITABLE;
            // if ESACC_ESFLADSMgt.PageGeneral(27, 31, TempBoolean) then//TODO:
            CurrPage.EDITABLE := TempBoolean;
        end;



        //ESACC_EasySecurityManual(OpenObject);
    end;

    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next);
    var
        MatrixMgt: Codeunit "Matrix Management";
        CaptionFieldNo: Integer;
        CurrentMatrixRecordOrdinal: Integer;
    begin
        //<VSO2183>

        // <TPZ159>
        //<TPZ2632>
        //MatrixRecord.SetSecurityFilter;
        //Table14EventPublishers.Tb14_OnSetSecurityFilter(MatrixRecord);//TODO:
        //</TPZ2632>
        // </TPZ159>
        MatrixRecord.SETRANGE("Use As In-Transit", ShowInTransit);

        CLEAR(MATRIX_CaptionSet);
        CLEAR(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        MatrixRecordRef.GETTABLE(MatrixRecord);
        MatrixRecordRef.SETTABLE(MatrixRecord);

        if ShowColumnName then
            CaptionFieldNo := MatrixRecord.FIELDNO(Name)
        else
            CaptionFieldNo := MatrixRecord.FIELDNO(Code);

        MatrixMgt.GenerateMatrixData(MatrixRecordRef, SetWanted, ARRAYLEN(MatrixRecords), CaptionFieldNo, MATRIX_PKFirstRecInCurrSet,
          MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrSetLength);

        if MATRIX_CurrSetLength > 0 then begin
            MatrixRecord.SETPOSITION(MATRIX_PKFirstRecInCurrSet);
            MatrixRecord.FIND;
            repeat
                MatrixRecords[CurrentMatrixRecordOrdinal].COPY(MatrixRecord);
                CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
            until (CurrentMatrixRecordOrdinal > MATRIX_CurrSetLength) or (MatrixRecord.NEXT <> 1);
        end;
        ////</VSO2183>
    end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyDeletion. Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.

}

