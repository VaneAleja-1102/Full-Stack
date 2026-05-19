import { Schema, model, Document } from "mongoose";

export interface ITestimonio {
    name      : string;
    photo     : string;
    text      : string;
    country   : string;
    instagram?: string;
    facebook? : string;
    status    : 'borrador' | 'publicado' | 'despublicado';
}

interface ITestimonioDocument extends ITestimonio, Document {}

const TestimonioSchema = new Schema<ITestimonioDocument>({
    name:      { type: String, required: true },
    photo:     { type: String, required: true },
    text:      { type: String, required: true },
    country:   { type: String, required: true },
    instagram: { type: String },
    facebook:  { type: String },
    status:    { type: String, enum: ['borrador', 'publicado', 'despublicado'], default: 'borrador' },
}, { timestamps: true });

export const TestimonioModel = model('Testimonio', TestimonioSchema);