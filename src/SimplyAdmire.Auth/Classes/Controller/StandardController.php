<?php
declare(strict_types = 1);

namespace SimplyAdmire\Auth\Controller;

use Neos\Flow\Annotations as Flow;
use Neos\Flow\Mvc\Controller\ActionController;
use Neos\Flow\Security\Context;
use Neos\Ldap\Service\DirectoryService;

class StandardController extends ActionController
{

    /**
     * @Flow\Inject
     * @var Context
     */
    protected $securityContext;

    /**
     *
     * @Flow\InjectConfiguration(path="security.authentication.providers.Ldap.providerOptions", package="Neos.Flow")
     * @var array
     */
    protected $ldapOptions;

    /**
     * @Flow\InjectConfiguration(path="security.authentication.providers.ActiveDirectory.providerOptions", package="Neos.Flow")
     * @var array
     */
    protected $activeDirectoryOptions;

    public function indexAction()
    {
        $this->view->assign('account', $this->securityContext->getAccount());
    }

    public function dashboardAction()
    {
        $activeDirectoryService = new DirectoryService(
            'ActiveDirectory',
            $this->activeDirectoryOptions
        );
        $activeDirectoryService->bindConnection();
        $result = \ldap_search(
            $activeDirectoryService->getConnection(),
            $this->activeDirectoryOptions['baseDn'],
            '(objectClass=user)'
        );
        $this->view->assign('activeDirectoryUsers', \ldap_get_entries($activeDirectoryService->getConnection(), $result));

        $ldapDirectoryService = new DirectoryService(
            'Ldap',
            $this->ldapOptions
        );
        $ldapDirectoryService->bindConnection();
        $result = \ldap_search(
            $ldapDirectoryService->getConnection(),
            $this->ldapOptions['baseDn'],
            '(objectClass=posixAccount)'
        );
        $this->view->assign('ldapUsers', \ldap_get_entries($ldapDirectoryService->getConnection(), $result));
    }

}