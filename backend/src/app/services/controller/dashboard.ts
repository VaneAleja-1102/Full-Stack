import { Request, Response } from 'express';
// Aquí importarías los modelos de solicitudes, testimonios y noticias
// cuando los tengas. Por ahora usamos datos simulados.

export class DashboardController {

  async getMetrics(req: Request, res: Response) {
    const user = req.user; // Ya viene del middleware authenticate

    try {
      if (user.role === 'superadmin') {
        // Superadmin ve métricas GLOBALES de todos los países
        const metrics = {
          role: 'superadmin',
          // Cuando tengas los modelos reales, harías:
          // pendingRequests: await RequestModel.countDocuments({ status: 'pending' }),
          // publishedTestimonials: await TestimonialModel.countDocuments({ published: true }),
          // activeNews: await NewsModel.countDocuments({ active: true }),
          pendingRequests: 42,       // ← reemplazar con query real
          publishedTestimonials: 18,
          activeNews: 7,
          breakdown_by_country: [
            { country: 'Colombia', pending: 15 },
            { country: 'México', pending: 27 },
          ]
        };
        return res.status(200).json({ ok: true, metrics });
      }

      if (user.role === 'admin_pais' || user.role === 'editor') {
        // Solo ven datos de SU país
        const metrics = {
          role: user.role,
          country: user.country,
          // pendingRequests: await RequestModel.countDocuments({ 
          //   status: 'pending', country: user.country 
          // }),
          pendingRequests: 10,
          publishedTestimonials: 5,
          activeNews: 3,
        };
        return res.status(200).json({ ok: true, metrics });
      }

    } catch (error) {
      return res.status(500).json({ ok: false, error_message: 'Error obteniendo métricas' });
    }
      return;
  }

}