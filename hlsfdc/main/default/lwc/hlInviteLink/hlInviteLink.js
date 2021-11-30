import { LightningElement} from 'lwc';
import getInviteLink from '@salesforce/apex/HLSessionController.getInviteLink';

export default class HlInviteLink extends LightningElement {
    link;
    error;

    connectedCallback() {
        console.log('here')
        getInviteLink()
            .then(result => {
                this.link = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleCopy(e) {
        // can't use the native js clipboard api in salesforce, so we need to create a hidden input
        const hiddenInput = document.createElement("input");
        hiddenInput.setAttribute("value", this.link);
        document.body.appendChild(hiddenInput);
        hiddenInput.select();
        document.execCommand("copy");
        document.body.removeChild(hiddenInput); 
    }

}