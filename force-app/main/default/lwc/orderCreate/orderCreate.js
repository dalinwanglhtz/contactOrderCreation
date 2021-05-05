import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ORDERSTARTDATE_FIELD from '@salesforce/schema/Order.EffectiveDate';
import ACCOUNTNAME_FIELD from '@salesforce/schema/Order.AccountId';
import STATUS_FIELD from '@salesforce/schema/Order.Status';
import CONTACT1_FIELD from '@salesforce/schema/Order.CustomerAuthorizedById';

export default class OrderCreate extends LightningElement {
    orderStartDate = ORDERSTARTDATE_FIELD;
    accountId = ACCOUNTNAME_FIELD;
    status = STATUS_FIELD;
    customerAuthorizedById = CONTACT1_FIELD;

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Order Created",
            message: "Record ID: "+event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
    }
}