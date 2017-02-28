<?php
declare(strict_types = 1);

namespace SimplyAdmire\Auth\Controller;

use Neos\Flow\Mvc\ActionRequest;
use Neos\Flow\Security\Authentication\Controller\AbstractAuthenticationController;

class AuthenticationController extends AbstractAuthenticationController
{

    /**
     * @param ActionRequest $originalRequest The request that was intercepted by the security framework, NULL if there was none
     * @return string
     */
    protected function onAuthenticationSuccess(ActionRequest $originalRequest = null)
    {
        $this->redirect('index', 'Standard');
    }

    public function logoutAction()
    {
        parent::logoutAction();
        $this->addFlashMessage('Logged out');
        $this->redirect('login');
    }

}