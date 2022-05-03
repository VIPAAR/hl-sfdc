import { LightningElement, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/HLContactListController.getContacts';

/** The delay used when debouncing event handlers before invoking Apex. */
const DELAY = 500;

const columns = [
    { label: 'Avatar', fieldName: 'avatarURL', type:"image" }, 
    { label: 'Name', fieldName: 'name' , type:'text' }, 
    { type: "button", typeAttributes: {  
        label: 'Call',  
        name: 'Call',  
        title: 'Call',  
        disabled: false,  
        value: 'call',  
        iconPosition: 'right'
    }}
]; 
export default class HlContacts extends LightningElement {
    searchTerm = '';
    columns = columns;
    page = 1;
    totalEntries;
    totalPages;
    delayTimeout;
    isLoading;
    @track enableInfiniteLoading;
    @track loadMoreStatus;
    @track contacts;
    @track error;

    handleGetContacts() {
        this.isLoading = true;
        getContacts({ searchTerm: this.searchTerm,  pageNumber: this.page })
            .then((result) => {
                this.contacts = result.entries;
                this.totalEntries = result.totalEntries;
                this.totalPages = result.totalPages;
                this.error = undefined;
                if (result.entries.length != result.totalEntries) {
                    this.enableInfiniteLoading = true;
                }
                this.isLoading = false;
            })
            .catch((error) => {
                this.error = error;
                this.contacts = undefined;
                this.isLoading = false;
            });
    }

    connectedCallback() {
        this.handleGetContacts();
    }

    handleTermChange(event) {
        this.contacts = null;
        window.clearTimeout(this.delayTimeout)
        const searchTerm = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.page = 1;
            this.searchTerm = searchTerm;
            this.handleGetContacts();
        }, DELAY);
    }

    loadMoreData(e) {
        this.loadMoreStatus = 'Loading';
        if (!this.isLoading) {
            this.isLoading = true;
            getContacts({ searchTerm: this.searchTerm,  pageNumber: this.page + 1 }) 
                .then((data) => {
                    const currentData = this.contacts;
                    if (currentData.length < this.totalEntries) {
                        const newData = currentData.concat(data.entries);
                        this.contacts = newData;
                        this.page = data.page;
                    }
                    this.isLoading = false;
                    this.loadMoreStatus = '';
                });
            this.isLoading = false;
        }
    }

    callRowAction(e) {  
        const record = e.detail.row;  
        const actionName = e.detail.action.name;
        
        if ( actionName === 'Call' ) {  
            this.handleCall(record.email)
        }        
    }  

    handleCall(email) {
        const valueChangeEvent = new CustomEvent("callcontact", {
            detail: { email: email }
        });
        this.dispatchEvent(valueChangeEvent);
    }
} 