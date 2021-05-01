import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {v4} from "uuid"
import fetch from "node-fetch"
import * as fs from "fs";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

interface InvoiceItem {
    description:string
    shift:string
    rate:number
    units:number
}

interface Invoice {
    from:string
    to:string
    invoiceNumber?:number
    date:Date
    dueDate:Date
    items:InvoiceItem[]
}

export const uploadTimesheet = functions.https.onCall(async (data:string,context)) => {

}

export const helloWorld = functions.https.onCall(async (data:string,context) => {
    const filename = v4()+".pdf";
    const app = admin.apps.length>0 ? admin.app("inita"): admin.initializeApp({},"inita");
    const storage = app.storage().bucket("gs://femiadeniyi.appspot.com");
    const file = storage.file("invoices/"+filename)

    const json:Invoice = JSON.parse(data);
    const body = {
        from:"",
        to:"",
        currency:"gbp",
        items:json.items.map(f => {
            return ({
                name:f.shift+" "+f.description,
                quantity:f.units,
                unit_cost:f.rate
            })
        })
    }




    const resp = await fetch("https://invoice-generator.com",{
        method:"POST",
        headers: {
            "Content-Type":"application/json"
        },
        body:JSON.stringify(body)
    });

    if(!resp.ok){
        return {resp:null}
    }


    const dest = fs.createWriteStream("/tmp/"+filename,);
    resp.body.pipe(dest);

    await new Promise((resolve, reject) => {
        dest.on("finish",()=>{
            fs.createReadStream("/tmp/"+filename)
                .pipe(file.createWriteStream({
                    resumable:false,
                    contentType:"application/pdf",
                    metadata:{
                        "Content-Disposition":"attachment"
                    }
                }))
                .on('error', function(err) {reject()})
                .on('finish', function() {
                    resolve()
                });
        })
    })

    const [link] = await new Promise((resolve, reject) => {
        file.getSignedUrl({
            version: 'v4',
            action: 'read',
            expires: Date.now() + 5 * 60 * 1000, // 15 minutes
        }).then(resolve).then(reject)
    })


    console.log(link)
    return {link}

});
