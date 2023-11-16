import { LightningElement, track, wire, api } from 'lwc';
import getSimilarCases from "@salesforce/apex/SimilarCaseController.getSimilarCases";

// define datatable columns with Case Number URL column
const columns = [
    {
        label: "Case",
        fieldName: "URLField",
        hideDefaultActions: true,
        type: "url",
        typeAttributes: {
            label: {
                fieldName: "CaseNumber", 
            },
            target: "_blank"
        },
        sortable: true
    },
    { label: "Subject", fieldName: "Subject", hideDefaultActions: true },
    { label: "Type", fieldName: "Type", hideDefaultActions: true }
];

export default class SimilarCasesLwc extends LightningElement {

    @api recordId; // Id passed from record page
    @track records; // Datatable records
    @track columns = columns; // Datatable columns
    @track hasData = false; // Indicator for whether data is present

    // Get suggest Cases based on Case Id
    @wire(getSimilarCases, { caseId: "$recordId" })
    wireCases({ error, data }) {
        if (data) {
            // Transform the data to include the URLField
            this.records = data.map((item) => ({
                ...item,
                URLField: `/lightning/r/Case/${item.Id}/view`
            }));

            this.hasData = this.records.length > 0;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    }
}
