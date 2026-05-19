import { Schema, model, Document } from "mongoose";

export interface ICountry {
    name   : string;
    code   : string;
    flag   : string;
    domain?: string;
    status : 'active' | 'inactive';
}

interface ICountryDocument extends ICountry, Document {}

const CountrySchema = new Schema<ICountryDocument>({
    name:   { type: String, required: true, unique: true },
    code:   { type: String, required: true, unique: true },
    flag:   { type: String, required: true },
    domain: { type: String },
    status: { type: String, enum: ['active', 'inactive'], default: 'active' },
}, { timestamps: true });

export const CountryModel = model('Country', CountrySchema);