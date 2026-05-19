import { Request, Response } from "express";
import { TestimonioModel } from "../../models/testimonio";

export class TestimonioController {

    async getAll(req: Request, res: Response): Promise<any> {
        try {
            const user = req.user;
            let filter: any = {};
            if (user.role !== 'superadmin') filter.country = user.country;
            const testimonios = await TestimonioModel.find(filter).sort({ createdAt: -1 });
            return res.status(200).json({ ok: true, testimonios });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error obteniendo testimonios' });
        }
    }

    async create(req: Request, res: Response): Promise<any> {
        try {
            const user = req.user;
            const data = { ...req.body };
            if (user.role !== 'superadmin') data.country = user.country;
            const testimonio = await TestimonioModel.create(data);
            return res.status(200).json({ ok: true, testimonio });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error creando testimonio' });
        }
    }

    async update(req: Request, res: Response): Promise<any> {
        try {
            const testimonio = await TestimonioModel.findByIdAndUpdate(req.params.id, req.body, { new: true });
            if (!testimonio) return res.status(404).json({ ok: false, error_message: 'Testimonio no encontrado' });
            return res.status(200).json({ ok: true, testimonio });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error actualizando testimonio' });
        }
    }

    async updateStatus(req: Request, res: Response): Promise<any> {
        try {
            const { status } = req.body;
            const testimonio = await TestimonioModel.findByIdAndUpdate(req.params.id, { status }, { new: true });
            if (!testimonio) return res.status(404).json({ ok: false, error_message: 'Testimonio no encontrado' });
            return res.status(200).json({ ok: true, testimonio });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error actualizando estado' });
        }
    }

    async remove(req: Request, res: Response): Promise<any> {
        try {
            const user = req.user;
            const testimonio = await TestimonioModel.findById(req.params.id);
            if (!testimonio) return res.status(404).json({ ok: false, error_message: 'Testimonio no encontrado' });
            if (user.role !== 'superadmin' && testimonio.country !== user.country) {
                return res.status(403).json({ ok: false, error_message: 'No puedes eliminar testimonios de otro país' });
            }
            await TestimonioModel.findByIdAndDelete(req.params.id);
            return res.status(200).json({ ok: true, message: 'Testimonio eliminado' });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error eliminando testimonio' });
        }
    }
}