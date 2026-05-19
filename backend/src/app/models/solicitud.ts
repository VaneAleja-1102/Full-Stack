import { Schema, model, Document } from "mongoose";

export interface ISolicitud {
    name     : string;
    email    : string;
    phone    : string;
    finalidad: string;
    country  : string;
    message  : string;
    status   : 'pendiente' | 'gestionada' | 'respondida';
}

interface ISolicitudDocument extends ISolicitud, Document {}

const SolicitudSchema = new Schema<ISolicitudDocument>({
    name:      { type: String, required: true },
    email:     { type: String, required: true },
    phone:     { type: String, required: true },
    finalidad: { type: String, required: true },
    country:   { type: String, required: true },
    message:   { type: String, required: true },
    status:    { type: String, enum: ['pendiente', 'gestionada', 'respondida'], default: 'pendiente' },
}, { timestamps: true });

export const SolicitudModel = model('Solicitud', SolicitudSchema);