//
//  GallaryVC.swift

import UIKit

class GallaryVC: UIViewController {

    // MARK: - IBOutlets
    // ----------------
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Declarations
    // --------------------
    private var gallatyViewModel = GallaryViewModel()
    var searchText:String? = nil
    var photosArray:[ImagesData] = [] {
        didSet{
            self.collectionView.reloadData()
            self.title = "Gallary (\(photosArray.count))"
        }
    }
    var numberOfCellInRow = 3
    
    // MARK: - View Controller Lifecycle
    // ---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gallary"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getSearchedResult()
    }
    
    func getSearchedResult(){
        self.configuration()
    }
    
}
extension GallaryVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.photosArray.count
        }
        
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: CellName.PhotosCell, for: indexPath) as? PhotosCell else {
            return UICollectionViewCell()
        }
        cell.imageObj = self.photosArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = numberOfCellInRow
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: size)
        }
        return CGSize.zero
    }
}

extension GallaryVC{
    
    func configuration(){
        self.initViewModel()
        self.observeEvent()
    }
    
    func initViewModel(){
        self.collectionView?.register(UINib(nibName: CellName.PhotosCell, bundle: nil), forCellWithReuseIdentifier: CellName.PhotosCell)
        if let searchString = self.searchText {
            gallatyViewModel.fetchSearchedPhotos(searchText: searchString)
        }
    }
    
    
    func observeEvent(){
        gallatyViewModel.eventHandler = {[weak self] eventType in
            guard let self else {
                return
            }
            
            switch eventType {
            case .loading:
                self.startActivityIndicator()
            case .stoploading:
                self.stopActivityIndicator()
            case .dataLoaded:
                DispatchQueue.main.async {
                    if let gallaryData = self.gallatyViewModel.gallaryData {
                        self.photosArray = gallaryData.images ?? []
                    }
                }
            case .error(let error):
                self.showAlertMessage(messageStr: error?.localizedDescription ?? "")
            }
        }
    }
}
