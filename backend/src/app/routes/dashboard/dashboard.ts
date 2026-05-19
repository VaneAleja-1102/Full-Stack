import { Router } from 'express';
import { RoutesApp } from '../../../core/routes';
import { DashboardController } from '../../services/controller/dashboard';
import { authenticate, authorize } from '../../middlewares/auth.middleware';

export class DashboardRoutes extends RoutesApp {
  public router: Router;
  private dashboardController: DashboardController;

  constructor() {
    super();
    this.router = Router();
    this.dashboardController = new DashboardController();
    this.setServicesRoutes();
  }

  protected setServicesRoutes(): void {
    // authenticate → verifica que el JWT sea válido
    // authorize(roles) → verifica que el rol tenga permiso
    this.router.get(
      '/metrics',
      authenticate,                                    // primero autenticar
      authorize('superadmin', 'admin_pais', 'editor'), // luego autorizar
      this.dashboardController.getMetrics.bind(this.dashboardController)
    );
  }
}