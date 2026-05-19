import { Schema, model, Document } from "mongoose";

export interface INoticia {
    title  : string;
    summary: string;
    content: string;
    country: string;
    author : string;
    status : 'borrador' | 'publicado';
    imageUrl?: string;
}

interface INoticiaDocument extends INoticia, Document {}

const NoticiaSchema = new Schema<INoticiaDocument>({
    title:    { type: String, required: true },
    summary:  { type: String, required: true },
    content:  { type: String, required: true },
    country:  { type: String, required: true },
    author:   { type: String, required: true },
    status:   { type: String, enum: ['borrador', 'publicado'], default: 'borrador' },
    imageUrl: { type: String },
}, { timestamps: true });

export const NoticiaModel = model('Noticia', NoticiaSchema);