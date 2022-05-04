import LightningDatatable from 'lightning/datatable';
import avatarControl from './avatarControl.html';

export default class SalesforceCodexDataTable extends LightningDatatable  {
    static customTypes = {
        image: {
            template: avatarControl
        }
    };
}