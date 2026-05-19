import { Request, Response } from "express";
import { SolicitudModel } from "../../models/solicitud";

export class SolicitudController {

    async getAll(req: Request, res: Response): Promise<any> {
        try {
            const user = req.user;
            const { status, country } = req.query;
            let filter: any = {};

            if (user.role !== 'superadmin') {
                filter.country = user.country;
            } else if (country) {
                filter.country = country;
            }

            if (status) filter.status = status;

            const solicitudes = await SolicitudModel.find(filter).sort({ createdAt: -1 });
            return res.status(200).json({ ok: true, solicitudes });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error obteniendo solicitudes' });
        }
    }

    async getOne(req: Request, res: Response): Promise<any> {
        try {
            const solicitud = await SolicitudModel.findById(req.params.id);
            if (!solicitud) return res.status(404).json({ ok: false, error_message: 'Solicitud no encontrada' });
            return res.status(200).json({ ok: true, solicitud });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error obteniendo solicitud' });
        }
    }

    async create(req: Request, res: Response): Promise<any> {
        try {
            const solicitud = await SolicitudModel.create(req.body);
            return res.status(200).json({ ok: true, solicitud });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error creando solicitud' });
        }
    }

    async updateStatus(req: Request, res: Response): Promise<any> {
        try {
            const { id } = req.params;
            const { status } = req.body;
            const solicitud = await SolicitudModel.findByIdAndUpdate(id, { status }, { new: true });
            if (!solicitud) return res.status(404).json({ ok: false, error_message: 'Solicitud no encontrada' });
            return res.status(200).json({ ok: true, solicitud });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error actualizando solicitud' });
        }
    }

    async remove(req: Request, res: Response): Promise<any> {
        try {
            const user = req.user;
            const solicitud = await SolicitudModel.findById(req.params.id);
            if (!solicitud) return res.status(404).json({ ok: false, error_message: 'Solicitud no encontrada' });
            if (user.role !== 'superadmin' && solicitud.country !== user.country) {
                return res.status(403).json({ ok: false, error_message: 'No puedes eliminar solicitudes de otro país' });
            }
            await SolicitudModel.findByIdAndDelete(req.params.id);
            return res.status(200).json({ ok: true, message: 'Solicitud eliminada' });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error eliminando solicitud' });
        }
    }
}