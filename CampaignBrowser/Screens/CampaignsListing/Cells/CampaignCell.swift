import UIKit
import RxSwift


/**
 The cell which displays a campaign.
 */
class CampaignCell: UICollectionViewCell {

    private let disposeBag = DisposeBag()

    /** Used to display the campaign's title. */
    @IBOutlet private(set) weak var nameLabel: UILabel!

    /** Used to display the campaign's description. */
    @IBOutlet private(set) weak var descriptionLabel: UILabel!

    /** The image view which is used to display the campaign's mood image. */
    @IBOutlet private(set) weak var imageView: UIImageView!

    /** The mood image which is displayed as the background. */
    var moodImage: Observable<UIImage>? {
        didSet {
            moodImage?
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] image in
                    self?.imageView.image = image
                    })
                .disposed(by: disposeBag)
        }
    }

    /** The campaign's name. */
    var name: String? {
        didSet {
            nameLabel?.text = name
        }
    }

    var descriptionText: String? {
        didSet {
            descriptionLabel?.text = descriptionText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        assert(nameLabel != nil)
        assert(descriptionLabel != nil)
        assert(imageView != nil)
    }
    
    // https://developer.apple.com/documentation/uikit/uicollectionreusableview/1620132-preferredlayoutattributesfitting
    // We can use preferredLayoutAttributesFitting(_:). This come from UICollectionReusableView.
    // It gives the cell a chance to modify the attributes provided by the layout object.
    // These attributes represent the values that the layout intends to apply to the cell.
    // Finaly it returns the attributes to apply to the cell
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // getting size prefferd attributes of super
        let collectionViewLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        // target estimates
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        // setting layout size priority to Width, as we have fix width to available space as per device.
        // height can vary with content available
        let autoLayoutSize = systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
        // frame with autoLayout calculations
        let autoLayoutFrame = CGRect(origin: collectionViewLayoutAttributes.frame.origin, size: autoLayoutSize)
        // updating collectionViewLayoutAttributes frame and returning
        collectionViewLayoutAttributes.frame = autoLayoutFrame
        return collectionViewLayoutAttributes
    }
}
