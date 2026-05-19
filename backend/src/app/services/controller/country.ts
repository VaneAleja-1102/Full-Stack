import { Request, Response } from "express";
import { CountryModel } from "../../models/country";

export class CountryController {

    async getAll(_req: Request, res: Response): Promise<any> {
        try {
            const countries = await CountryModel.find();
            return res.status(200).json({ ok: true, countries });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error obteniendo países' });
        }
    }

    async create(req: Request, res: Response): Promise<any> {
        try {
            const { name, code, flag, domain, status } = req.body;
            const exists = await CountryModel.findOne({ code });
            if (exists) return res.status(400).json({ ok: false, error_message: 'Ya existe ese país' });
            const country = await CountryModel.create({ name, code, flag, domain, status: status || 'active' });
            return res.status(200).json({ ok: true, country });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error creando país' });
        }
    }

    async updateStatus(req: Request, res: Response): Promise<any> {
        try {
            const { id } = req.params;
            const { status } = req.body;
            const country = await CountryModel.findByIdAndUpdate(id, { status }, { new: true });
            if (!country) return res.status(404).json({ ok: false, error_message: 'País no encontrado' });
            return res.status(200).json({ ok: true, country });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error actualizando país' });
        }
    }

    async remove(req: Request, res: Response): Promise<any> {
        try {
            const { id } = req.params;
            const country = await CountryModel.findByIdAndDelete(id);
            if (!country) return res.status(404).json({ ok: false, error_message: 'País no encontrado' });
            return res.status(200).json({ ok: true, message: 'País eliminado' });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error eliminando país' });
        }
    }
}