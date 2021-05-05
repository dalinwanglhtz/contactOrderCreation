import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createAcctContRelation from '@salesforce/apex/ContactCreateController.createAccountContactRelation';


import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import ACCOUNTNAME_FIELD from '@salesforce/schema/Contact.AccountId';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import MOBILEPHONE_FIELD from '@salesforce/schema/Contact.MobilePhone';
import CONTACTROLE_FIELD from '@salesforce/schema/Contact.Contact_Role__c';

export default class ContactCreate extends LightningElement {
    @api recordId;
    @track error;

    firstName = FIRSTNAME_FIELD;
    lastName = LASTNAME_FIELD;
    accountId = ACCOUNTNAME_FIELD;
    email = EMAIL_FIELD;
    mobilePhone = MOBILEPHONE_FIELD;
    contactRole = CONTACTROLE_FIELD;

    handleSuccess(event) {
        saveACRelation(event);
        const evt = new ShowToastEvent({
            title: "Contact Created",
            message: "Record ID: "+event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
    }

    saveACRelation(event) {
        createAcctContRelation({contactId: event.detail.id})
        .then(result => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!!',
                message: 'Account Contact Relation Created Successfully!!',
                variant: 'success'
            }));
        })
        .catch(error => {
            this.error = error.message;
        })
    }

}