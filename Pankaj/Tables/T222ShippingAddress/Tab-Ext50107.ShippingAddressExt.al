tableextension 50107 ShippingAddressExt extends "Ship-to Address"
{
    fields
    {
        Field(50057; "Address Verified"; Boolean) { }
        Field(51002; "Last Modified by User ID"; Code[50]) { }
        Field(51003; "Date Created"; Date) { }
        Field(51005; "Created by User ID"; Code[50]) { }
        Field(51041; "DUNS No."; Code[13]) { }
        Field(51096; "External Document No. Mask"; Code[35]) { }
        Field(51098; "Blocked"; Boolean) { }
        Field(51099; "Mailing Label"; Boolean) { }
        Field(51127; "Region Code"; Code[10]) { }
        Field(51128; "Territory Code"; Code[10]) { }
        Field(51129; "District"; Text[30]) { }
        Field(51900; "Electric Mfr. Rep. Code"; Code[10]) { }
        Field(51901; "Electric Salesperson Code"; Code[10]) { }
        Field(51902; "Electric ISR Code"; Code[10]) { }
        Field(51903; "Electric CSR Code"; Code[10]) { }
        Field(51904; "Electric Location Code"; Code[10]) { }
        Field(51905; "Cust Electric Location Code"; Code[10]) { }
        Field(51906; "Cust Lighiting Location Code"; Code[10]) { }
        Field(51908; "Electric Division"; Boolean) { }
        Field(51910; "Lighting Mfr. Rep. Code"; Code[10]) { }
        Field(51911; "Lighting Salesperson Code"; Code[10]) { }
        Field(51912; "Lighting ISR Code"; Code[10]) { }
        Field(51913; "Lighting CSR Code"; Code[10]) { }
        Field(51914; "Lighting Location Code"; Code[10]) { }
        Field(51918; "Lighting Division"; Boolean) { }
        Field(51919; "Nextwave Spec. Mfr. Rep. Code"; Code[10]) { }
        Field(51924; "International Location Code"; Code[10]) { }
        Field(51928; "International Division"; Boolean) { }
        Field(51930; "Freight Forward Allowed"; Boolean) { }
        Field(70551; "Redirect Exists"; Boolean) { }
        Field(70552; "Delete Pending"; Boolean) { }
        Field(70553; "Change Pending"; Boolean) { }
        Field(70554; "Exclude From Usage"; Boolean) { }

    }
}
