import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import ACCOUNTNAME_FIELD from '@salesforce/schema/Contact.AccountId';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import MOBILEPHONE_FIELD from '@salesforce/schema/Contact.MobilePhone';
import CONTACTROLE_FIELD from '@salesforce/schema/Contact.Contact_Role__c';

export default class ContactCreate extends NavigationMixin(LightningElement) {
    recordId;

    firstName = FIRSTNAME_FIELD;
    lastName = LASTNAME_FIELD;
    accountId = ACCOUNTNAME_FIELD;
    email = EMAIL_FIELD;
    mobilePhone = MOBILEPHONE_FIELD;
    contactRole = CONTACTROLE_FIELD;

    handleSuccess(event) {
        this.recordId = event.detail.id;
        const evt = new ShowToastEvent({
            title: "Contact Created",
            message: "Record ID: "+event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
        this.navigateToRecordPage();
    }

    navigateToRecordPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }
}