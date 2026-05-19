import { Request, Response } from "express";
import { NoticiaModel } from "../../models/noticia";

export class NoticiaController {

    async getAll(req: Request, res: Response): Promise<any> {
        try {
            const user = req.user;
            let filter: any = {};
            if (user.role !== 'superadmin') filter.country = user.country;
            const noticias = await NoticiaModel.find(filter).sort({ createdAt: -1 });
            return res.status(200).json({ ok: true, noticias });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error obteniendo noticias' });
        }
    }

    async create(req: Request, res: Response): Promise<any> {
        try {
            const user = req.user;
            const data = { ...req.body };
            if (user.role !== 'superadmin') data.country = user.country;
            const noticia = await NoticiaModel.create(data);
            return res.status(200).json({ ok: true, noticia });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error creando noticia' });
        }
    }

    async update(req: Request, res: Response): Promise<any> {
        try {
            const noticia = await NoticiaModel.findByIdAndUpdate(req.params.id, req.body, { new: true });
            if (!noticia) return res.status(404).json({ ok: false, error_message: 'Noticia no encontrada' });
            return res.status(200).json({ ok: true, noticia });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error actualizando noticia' });
        }
    }

    async updateStatus(req: Request, res: Response): Promise<any> {
        try {
            const { status } = req.body;
            const noticia = await NoticiaModel.findByIdAndUpdate(req.params.id, { status }, { new: true });
            if (!noticia) return res.status(404).json({ ok: false, error_message: 'Noticia no encontrada' });
            return res.status(200).json({ ok: true, noticia });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error actualizando estado' });
        }
    }

    async remove(req: Request, res: Response): Promise<any> {
        try {
            const user = req.user;
            const noticia = await NoticiaModel.findById(req.params.id);
            if (!noticia) return res.status(404).json({ ok: false, error_message: 'Noticia no encontrada' });
            if (user.role !== 'superadmin' && noticia.country !== user.country) {
                return res.status(403).json({ ok: false, error_message: 'No puedes eliminar noticias de otro país' });
            }
            await NoticiaModel.findByIdAndDelete(req.params.id);
            return res.status(200).json({ ok: true, message: 'Noticia eliminada' });
        } catch (error) {
            return res.status(500).json({ ok: false, error_message: 'Error eliminando noticia' });
        }
    }
}