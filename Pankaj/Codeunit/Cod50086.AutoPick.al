codeunit 50086 "Auto Pick"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        //PickingListnew:	Report	"Picking List -new";	
        WarehouseRequest: Record "Warehouse Request";
    //OutboundWhseRequestMgt:	Codeunit "outbound Whse. Request Mgt.";	
    //OutboundWhseRequestFilter:	Record	"Outbound Whse. Request Filter";	
    //Codeunit414EventSubscriber:	Codeunit	Codeunit414EventSubscriber;	
    begin
        SalesHeader.GET(SalesHeader."Document Type"::Order, SELECTSTR(2, rec."Parameter String"));
        //IF OutboundWhseRequestFilter.GET('DEFAULT') THEN;
        //OutboundWhseRequestFilter."Print Document" := FALSE;
        WarehouseRequest.RESET;
        WarehouseRequest.SETRANGE("Source Type", 37);
        WarehouseRequest.SETRANGE("Source Document", WarehouseRequest."Source Document"::"Sales Order");
        WarehouseRequest.SETRANGE("Source No.", SalesHeader."No.");
        WarehouseRequest.SETRANGE("Location Code", SalesHeader."Location Code");
        IF WarehouseRequest.FINDFIRST THEN;
        //OutboundWhseRequestMgt.CreatePick(WarehouseRequest, OutboundWhseRequestFilter, '', '');

        //>> VAH bug fix 
        //IF Codeunit414EventSubscriber.CU414_PickEmailExists(SalesHeader) THEN
        //Codeunit414EventSubscriber.CU414_CreateJobQueueForSendingPick(SalesHeader);
    end;

}
