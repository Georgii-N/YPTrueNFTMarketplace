//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Тихтей  Павел on 31.07.2023.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func updateProfile(profile: Profile)
}

class ProfileViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: ProfileViewModelProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavBar()
        setupConstrains()
        viewModel?.profileObservable.bind(action: { [weak self] _ in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.unblockUI, with: ())
            self.resumeMethodOnMainThread(self.isNavigationBarClear, with: false)
            self.setupProfile()
        })
        
        viewModel?.showErrorAlert = { [weak self] message in
            guard let self else { return }
            self.resumeMethodOnMainThread(self.unblockUI, with: ())
            self.resumeMethodOnMainThread(self.isNavigationBarClear, with: false)
            self.resumeMethodOnMainThread(self.showNotificationBanner, with: message)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isNavigationBarClear(true)
        blockUI(withBlur: true)
        viewModel?.fetchProfile()
    }

    // MARK: - Init

    init(viewModel: ProfileViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    
    private func setupBackground() {
        view.backgroundColor = .whiteDay
        view.tintColor = .blackDay
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Resources.Images.editProfile,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(presentEditVC))
    }
    
    private lazy var profileAvatarImage: UIImageView = {
        var profileAvatarImage = UIImageView()
        profileAvatarImage.backgroundColor = .lightGray
        profileAvatarImage.layer.cornerRadius = 35
        profileAvatarImage.clipsToBounds = true
        profileAvatarImage.image = Resources.Images.profileMockImage
        profileAvatarImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileAvatarImage)
        return profileAvatarImage
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let profileNameLabel = UILabel()
        profileNameLabel.font = .captionLargeBold
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.07
        profileNameLabel.numberOfLines = 2
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileNameLabel)
        return profileNameLabel
    }()
    
    private lazy var profileDescriptionLabel: UILabel = {
        let profileDescriptionLabel = UILabel()
        profileDescriptionLabel.font = .bodySmallerRegular
        let attributedText = NSMutableAttributedString(string: profileDescriptionLabel.text ?? "")
        let paragrapthStyle = NSMutableParagraphStyle()
        paragrapthStyle.lineSpacing = 5
        attributedText.addAttribute(.paragraphStyle, value: paragrapthStyle, range: NSRange(location: 0, length: attributedText.length))
        profileDescriptionLabel.attributedText = attributedText
        profileDescriptionLabel.numberOfLines = 0
        profileDescriptionLabel.lineBreakMode = .byWordWrapping
        profileDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileDescriptionLabel)
        return profileDescriptionLabel
    }()
    
    private lazy var profileSite: UILabel = {
        let profileSite = UILabel()
        profileSite.font = .bodySmallRegular
        profileSite.textColor = .blueUniversal
        profileSite.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileSite)
        return profileSite
    }()
    
    private lazy var profileTableView: UITableView = {
        let profileTableView = UITableView()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.separatorStyle = .none
        profileTableView.isScrollEnabled = false
        profileTableView.backgroundColor = .clear
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileTableView)
        return profileTableView
    }()
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            // Profile Avatar
            profileAvatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileAvatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileAvatarImage.widthAnchor.constraint(equalToConstant: 70),
            profileAvatarImage.heightAnchor.constraint(equalToConstant: 70),
            
            // Profile Name
            profileNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImage.trailingAnchor, constant: 16),
            profileNameLabel.centerYAnchor.constraint(equalTo: profileAvatarImage.centerYAnchor),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Profile Description
            profileDescriptionLabel.topAnchor.constraint(equalTo: profileAvatarImage.bottomAnchor, constant: 20),
            profileDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Profile Site
            profileSite.topAnchor.constraint(equalTo: profileDescriptionLabel.bottomAnchor, constant: 12),
            profileSite.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileSite.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Profile Table View
            profileTableView.topAnchor.constraint(equalTo: profileSite.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupProfile() {
        DispatchQueue.main.async { [weak self] in
            guard let self,
                  let profile = self.viewModel?.profileObservable.wrappedValue,
            let avatarUrl = URL(string: profile.avatar) else { return }
            self.profileNameLabel.text = profile.name
            self.profileDescriptionLabel.text = profile.description
            self.profileSite.text = profile.website
            self.profileAvatarImage.kf.setImage(with: avatarUrl)
            self.profileTableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc func presentEditVC() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.profile = viewModel?.profileObservable.wrappedValue
        editProfileViewController.delegate = self
        present(editProfileViewController, animated: true)
    }
}

    // MARK: - UITableViewDelegate&UITableViewDataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: Resources.Images.Authorization.forwardButtonImage)
        cell.textLabel?.font = .bodyMediumBold
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        let profile = viewModel?.profileObservable.wrappedValue
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = L10n.Profile.MainScreen.myNFT + " (\(profile?.nfts.count ?? 0))"
        case 1:
            cell.textLabel?.text = L10n.Profile.MainScreen.favouritesNFT + " (\(profile?.likes.count ?? 0))"
        case 2:
            cell.textLabel?.text = L10n.Profile.MainScreen.aboutDeveloper
        default:
            cell.textLabel?.text =  ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let myNFTViewModel = MyNFTViewModel(dataProvider: DataProvider())
            let myNFTVC = MyNFTViewController(viewModel: myNFTViewModel)
            myNFTVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(myNFTVC, animated: true)
        case 1:
            let favouritesNFTViewModel = FavouritesNFTViewModel(dataProvider: DataProvider())
            let favouritesNFT = FavouritesNFTViewController(viewModel: favouritesNFTViewModel)
            favouritesNFT.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(favouritesNFT, animated: true)
        case 2:
            guard let url = URL(string: profileSite.text ?? "") else { return }
            let webViewViewModel = WebViewViewModel()
            let webViewController = WebViewViewController(viewModel: webViewViewModel, url: url)
            navigationController?.pushViewController(webViewController, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

// MARK: - ProfileViewControllerDelegate

extension ProfileViewController: ProfileViewControllerDelegate {
    func updateProfile(profile: Profile) {
        viewModel?.changeProfile(profile: profile)
    }
}
