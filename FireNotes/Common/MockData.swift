import Foundation

fileprivate let dateFormatter: DateFormatter = {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "MM/dd/yyyy hh:mma"
  return dateFormatter
}()

let mockNote: Note = .init(
  id: .init(),
  title: "Sushi Combo",
  body: "And My favorite class is the spy\n",
  creationDate: dateFormatter.date(from: "1/1/2018 6:59AM")!,
  lastEditDate: dateFormatter.date(from: "1/2/2018 7:59AM")!
)

let mockNotes: [Note] = [
  .init(
    id: .init(),
    title: "Sushi Combo",
    body: "And My favorite class is the spy\n",
    creationDate: dateFormatter.date(from: "1/1/2018 6:59AM")!,
    lastEditDate: dateFormatter.date(from: "1/2/2018 7:59AM")!
  ),
  .init(
    id: .init(),
    title: "Sushi Combo",
    body: "And My favorite class is the spy\n",
    creationDate: dateFormatter.date(from: "1/1/2018 6:59AM")!,
    lastEditDate: dateFormatter.date(from: "1/2/2018 7:59AM")!
  ),
  .init(
    id: .init(),
    title: "Sushi Combo",
    body: "And My favorite class is the spy\n",
    creationDate: dateFormatter.date(from: "1/1/2018 6:59AM")!,
    lastEditDate: dateFormatter.date(from: "1/2/2018 7:59AM")!
  )
]

let mockFolder: Folder = .init(
  id: .init(),
  variant: .user,
  name: "Machine Learning",
  notes: [
    .init(
      id: .init(),
      title: "Logistic Regression",
      body: """
      A wonderful introduction to neural networks. These models are incredibly simple and layout groundwork for understanding more complex model architecture.
      """,
      creationDate: dateFormatter.date(from: "1/1/2020 6:59AM")!,
      lastEditDate: dateFormatter.date(from: "1/2/2020 6:59AM")!
    ),
    .init(
      id: .init(),
      title: "Learning Tasks",
      body: "There exist several cannonical learning tasks in ML. This includes supervised, unsupervised, and reinforcment learning.",
      creationDate: dateFormatter.date(from: "1/1/2020 6:59AM")!,
      lastEditDate: dateFormatter.date(from: "1/2/2020 6:59AM")!
    ),
    .init(
      id: .init(),
      title: "Gradient Optimizers",
      body: "We can transform our cost function to achieve faster learning, that is, moving towards the global optima in the most optimized way possible. Often, gradients can explode and vanish, and if this constantly occurs, or at least enough, the net trajectory of descent is noisy and ultimately inefficient towards the optima.",
      creationDate: dateFormatter.date(from: "1/10/2020 6:30AM")!,
      lastEditDate: dateFormatter.date(from: "1/20/2020 7:00AM")!
    ),
    .init(
      id: .init(),
      title: "Convolutions",
      body: "We can capture patterns in pixel data effectively by applying convolutions in our layers. Further, we can learn filter parameters without having to explicitly calculate, which is usually very difficult, and yields filters that are benefical in specific datasets. The result is a network which is far superior at learning vision data than traditional networks.",
      creationDate: dateFormatter.date(from: "2/10/2020 8:30AM")!,
      lastEditDate: dateFormatter.date(from: "2/20/2022 8:00AM")!
    ),
    .init(
      id: .init(),
      title: "Transformers",
      body: "Attention is all you need!",
      creationDate: dateFormatter.date(from: "3/4/2020 9:59AM")!,
      lastEditDate: dateFormatter.date(from: "3/5/2020 9:59AM")!
    )
  ]
)

let mockFolderA: Folder = .init(
  id: .init(),
  variant: .user,
  name: "Machine Learning",
  notes: [
    .init(
      id: .init(),
      title: "Logistic Regression",
      body: """
      A wonderful introduction to neural networks. These models are incredibly simple and layout groundwork for understanding more complex model architecture.
      """,
      creationDate: dateFormatter.date(from: "1/1/2020 6:59AM")!,
      lastEditDate: dateFormatter.date(from: "1/2/2020 6:59AM")!
    ),
    .init(
      id: .init(),
      title: "Learning Tasks",
      body: "There exist several cannonical learning tasks in ML. This includes supervised, unsupervised, and reinforcment learning.",
      creationDate: dateFormatter.date(from: "1/1/2020 6:59AM")!,
      lastEditDate: dateFormatter.date(from: "1/2/2020 6:59AM")!
    ),
    .init(
      id: .init(),
      title: "Gradient Optimizers",
      body: "We can transform our cost function to achieve faster learning, that is, moving towards the global optima in the most optimized way possible. Often, gradients can explode and vanish, and if this constantly occurs, or at least enough, the net trajectory of descent is noisy and ultimately inefficient towards the optima.",
      creationDate: dateFormatter.date(from: "1/10/2020 6:30AM")!,
      lastEditDate: dateFormatter.date(from: "1/20/2020 7:00AM")!
    ),
    .init(
      id: .init(),
      title: "Convolutions",
      body: "We can capture patterns in pixel data effectively by applying convolutions in our layers. Further, we can learn filter parameters without having to explicitly calculate, which is usually very difficult, and yields filters that are benefical in specific datasets. The result is a network which is far superior at learning vision data than traditional networks.",
      creationDate: dateFormatter.date(from: "2/10/2020 8:30AM")!,
      lastEditDate: dateFormatter.date(from: "2/20/2022 8:00AM")!
    ),
    .init(
      id: .init(),
      title: "Entropy Loss Function",
      body: "This function essentially measures the amount of uncertainty associated with a specific probability distribution. The higher the entropy, the less confident we are in the outcome. This is a very fundamental and rudimentary function that has been extrapolated to create very common and powerful loss functions such as Binary Cross Entropy.",
      creationDate: dateFormatter.date(from: "3/4/2020 7:00AM")!,
      lastEditDate: dateFormatter.date(from: "3/4/2020 8:00AM")!
    ),
    .init(
      id: .init(),
      title: "Mean Square Error Loss Function",
      body: "This function essentially measures how \"close\" a line is to a set of data points. This is a very simple, yet powerful loss function!",
      creationDate: dateFormatter.date(from: "3/5/2020 7:00AM")!,
      lastEditDate: dateFormatter.date(from: "3/5/2020 8:00AM")!
    ),
    .init(
      id: .init(),
      title: "Huber Loss Function",
      body: "This function essentially measures how \"close\" a line is to a set of data points! This function combines MSE and MAE together, resulting in a function that is more resillient to outliers, by learning them and ignoring them.",
      creationDate: dateFormatter.date(from: "3/6/2020 7:00AM")!,
      lastEditDate: dateFormatter.date(from: "3/6/2020 8:00AM")!
    ),
    .init(
      id: .init(),
      title: "Kullback-Liebler Divergence Loss Function",
      body: "This function essentially measures how two distributions are different based on their probablility distribtions. There is a great artical explaining the function: https://www.countbayesie.com/blog/2017/5/9/kullback-leibler-divergence-explained",
      creationDate: dateFormatter.date(from: "3/7/2020 7:00AM")!,
      lastEditDate: dateFormatter.date(from: "3/7/2020 8:00AM")!
    ),
    .init(
      id: .init(),
      title: "ANN History: 1 -- McCulloch-Pitts Neuron",
      body: "The very first documented artifical neuron was created in a 1943 Neural Circuit design by neurophysiologist Warren McCulloch and mathematician Walter Pitts. Formulated McCulloch-Pitts Neuron",
      creationDate: dateFormatter.date(from: "3/8/2020 7:00AM")!,
      lastEditDate: dateFormatter.date(from: "3/8/2020 8:00AM")!
    ),
    .init(
      id: .init(),
      title: "ANN History: 2 -- Hebbian Learning",
      body: "In 1949, Donald Hebb released The Organization of Behaviour (1949), postulating threshold logic and Hebbian Learning. In 1954, MIT implemented the first implementation of a Hebbian Network.",
      creationDate: dateFormatter.date(from: "3/8/2020 8:00AM")!,
      lastEditDate: dateFormatter.date(from: "3/8/2020 9:00AM")!
    ),
    .init(
      id: .init(),
      title: "ANN History: 3 -- Perceptron",
      body: "In 1958, Frank Rosenblatt invented the Mark I Perceptron.",
      creationDate: dateFormatter.date(from: "3/8/2020 10:00AM")!,
      lastEditDate: dateFormatter.date(from: "3/8/2020 11:00AM")!
    ),
  ]
)

let mockFolderB: Folder = .init(
  id: .init(),
  variant: .user,
  name: "Baking",
  notes: [
    .init(
      id: .init(),
      title: "White Chocolate Bourbon Bread Pudding",
      body: """
      Pudding
        Ingredients
          - 2 loafs homemade brioche bread
          - 4 cups heavy cream
          - 1 cup  sugar
          - 1/2 melted stick butter
          - 1 tsp  salt
          - 1 tbsp cinnamon
          - 1 tbsp vanilla extract
          - 1 pack white chocolate morsels
          - 1 cup  bourbon soaked golden raisins (optional)
          - 4 eggs lighly beaten
        Preparing
          - Cube bread into bite size pieces and allow to dry out and become stale.
            If you skip this step you will have soggy and disgusting pudding.
            Factory bread will turn into mush. Challah or french bread works well here as well.
          - Combine the cream, sugar, butter, salt, cinnamon, vanilla into a bowl
          - Combine eggs, morsels, and raisins into a bowl
          - Pour cream mixture onto bread followed by the egg mixture
          - Gently toss everything together. Go too fast and you will get mushy pile of garbage
          - Bake at 375F for 30-45 minutes or until golden and cooked through.
          - Let rest for 15 min then pour white chocolate bourbon sauce on the pudding and serve with
            vanilla icecream
      
      Sauce
        Ingredients
          - 1/2 stick butter
          - 1-2 shots bourbon
          - 1/2 pack white chocolate morsels
          - cream to texture
        Preparing
          - Add the butter and bourbon to a pot and cook until the alcohol is cooked off
          - Add a little bit of cream and bring to boil then put on simmer
          - Add your morsels and allow them to emulsify...if you cook them on high the sauce doens't emulsify properly,
            the delicate chocolate taste is lost, and its ruined
          - Add cream as you melt the chocolate to texture and as you see fit
      """,
      creationDate: dateFormatter.date(from: "12/1/2022 8:15PM")!,
      lastEditDate: dateFormatter.date(from: "12/2/2022 8:15PM")!
    ),
    .init(
      id: .init(),
      title: "Pecan Cobbler",
      body: """
        Crust
          - You favorite pre-baked pie crust, homemade shortcrust is king!
        Filling
          - 3 eggs
          - 1 cup dark corn syrup
          - 1 jar smuckers caramel
          - 1 stick butter
          - 1 shot bourbon
          - 1 tbsp vanilla
          - 2 cups pecans
          - 1 cup bourbon golden raisins (optional, and if added, don't add the shot of bourbon)
        Topping
          - Ice cream
          - White chocolate bourbon sauce
        
        Preparing
          - Mix all the fillings together and blend with electric beater for 2 minutes on high
          - Pour into crust
          - Bake at 375F for 45 min or until filling has a litle jiggle or set to your liking
          - Serve with those toppings!
        """,
      creationDate: dateFormatter.date(from: "12/1/2022 9:15PM")!,
      lastEditDate: dateFormatter.date(from: "12/23/2022 9:35PM")!
    ),
    .init(
      id: .init(),
      title: "Fig Cake",
      body: "Follow Paula Deen's recipe on it. It's really her brothers. Looks fantastic!",
      creationDate: dateFormatter.date(from: "12/4/2022 9:15PM")!,
      lastEditDate: dateFormatter.date(from: "12/4/2022 9:16PM")!
    ),
    .init(
      id: .init(),
      title: "Honey Cake",
      body: "Follow Chef John's recipe (FoodWishes). It's difficult but worth it!",
      creationDate: dateFormatter.date(from: "12/30/2022 9:00PM")!,
      lastEditDate: dateFormatter.date(from: "1/1/2023 7:00AM")!
    ),
  ]
)

let mockFolderC: Folder = .init(
  id: .init(),
  variant: .user,
  name: "Meal Prep",
  notes: [
    .init(
      id: .init(),
      title: "Chicken & Rice",
      body: """
      3 days of food:
      - 5.5 lb one-in skin-on chicken thighs ($1.50/lb * 5 = $8.25)
      - 5.0 lb rice bag ($5), use half a bag for 3 days
      - 1 quart chicken stock ($1.50)
      - 1 bottle George's hot bbq sauce ($2.50), uses half a bottle for 3 days
      
      Air fry the chicken
      Rice cooker the rice with chicken stock
      Shred the chicken, mix with rice, add bbq sauce to liking
      
      Total Cost:
        - $8.25 chicken
        - $2.50 rice
        - $0.75 stock
        - $1.25 sauce
      +
      __________________
      $12.75 / 3 days = $4.25/day
      """,
      creationDate: dateFormatter.date(from: "1/1/2023 7:00PM")!,
      lastEditDate: dateFormatter.date(from: "1/1/2023 7:00PM")!
    )
  ]
)
let mockFolderD: Folder = .init(
  id: .init(),
  variant: .user,
  name: "Gym",
  notes: [
    .init(
      id: .init(),
      title: "PPL",
      body: """
      My regiment:
      
      MO: Push
      TU: Pull
      WE: Leg
      TH: Push
      SA: Pull
      SU: Shoulders
      
      
      This is the split. I do abs on push and pull days. I deadlift on Tuesday and Tbar row on Thursday.
      Get massive.
      """,
      creationDate: dateFormatter.date(from: "1/1/2020 7:00PM")!,
      lastEditDate: dateFormatter.date(from: "1/1/2020 7:20PM")!
    ),
    .init(
      id: .init(),
      title: "Stats + Diet + Gear + Program",
      body: """
      My stats:
        M
        6"0
        234 lbs
        20% bf
        
      My diet:
        OMAD
        100-150g protein/day
        bone-in skin-on chicken thighs (3x)
        premier protein shakes (2x)
        carb/fat backfill
        generally 40%-ish fat cals
        water, plain tea, plain coffee only
        saturday cheat meal (sometimes nasty, sometimes not)
      
      My stack:
        - Turmeric-Curcumin Concentrate | skin/inflamation
        - Collagen                      | skin/health
        - Magnesium                     | energy/health
        - Creatine                      | energy/size
        - Turkestrone                   | energy/growth
      
      My regiment:
        - push-pull-leg-push-pull-shoulder
        - see my note about it
      """,
      creationDate: dateFormatter.date(from: "1/1/2020 7:20PM")!,
      lastEditDate: dateFormatter.date(from: "1/1/2020 8:00PM")!
    )
  ]
)
let mockFolderE: Folder = .init(
  id: .init(),
  variant: .user,
  name: "Data Structures",
  notes: [
    .init(
      id: .init(),
      title: "Red-Black Trees",
      body: """
      High performance tree data structure.
      You don't want to look into how it works. It's too complicated.
      However, we know operations can be very fast:
      - lookup: O(log(n))
      - insert: O(log(n))
      - delete: O(log(n))
      
      These operations are O(log(n)), but under the hood it is really O(h),
      where h represents the height of tree, which happens to be log(n) due
      to balancing the tree. Neat!
      """,
      creationDate: dateFormatter.date(from: "1/1/2018 7:00PM")!,
      lastEditDate: dateFormatter.date(from: "1/1/2018 7:15PM")!
    ),
    .init(
      id: .init(),
      title: "Hash Tables",
      body: """
      Super performant data structure for getting and setting data into a collection.
      All operations are O(1). Store elements as a key-value pair, where the key is
      "hashed", meaning a generic is transformed into a number. Must minimize hash
      collisions as this could lead to many disatrous events.
      """,
      creationDate: dateFormatter.date(from: "1/1/2018 7:00PM")!,
      lastEditDate: dateFormatter.date(from: "1/1/2018 7:15PM")!
    ),
    .init(
      id: .init(),
      title: "Disjoint Sets",
      body: """
      An unordered collection of elements that does not contain duplicates, and can
      perform operations seen in Set Theory. Possibly implemented with trees, but
      most commonly implemented using hash tables for maximal performance.
      """,
      creationDate: dateFormatter.date(from: "1/1/2018 7:00PM")!,
      lastEditDate: dateFormatter.date(from: "1/1/2018 7:15PM")!
    ),
    .init(
      id: .init(),
      title: "Transitive Closure",
      body: """
      Property stating that given edges u -> v, v -> w, then u -> w. This theory
      was used to address reachability in graph theory.
      """,
      creationDate: dateFormatter.date(from: "1/1/2018 7:00PM")!,
      lastEditDate: dateFormatter.date(from: "1/1/2018 7:15PM")!
    ),
  ]
)
let mockFolderF: Folder = .init(
  id: .init(),
  variant: .user,
  name: "Rust",
  notes: [
    .init(
      id: .init(),
      title: "Rust & Pointers",
      body: """
      Systems programming language with memory saftey. You get to handle memory, but the compiler
      prevents situations where invalid memory may be accessed or shared in a manner in which it
      shouldn't. Rust has many different data types representing pointers. References are versions of
      pointers that come in several very useful flavors that prevent chaos:
        - Shared References
          - when you create a shared reference (which you may create any number of) to a value,
            the value becomes immutable until all shared references are deleted
              - i.e. the references are "borrowers" and the initial variable that holds the value is the
                "owner"...the borrowers cannot change the what the owner owns underneath him
              - however, if the value has internal mutability, then this is not guarenteed (i.e. a method?)
          - written as: &type, or &'a type when you need to specify an explicit lifetime
          - copying a reference is a "shallow" operation
              - it involves only copying the pointer itself, that is, pointers are Copy
          - releasing a reference has no effect on the value it points to
          - referencing of a temporary value will keep it alive during the scope of the reference itself

        - Mutable References
          - written as: &mut type or &'a mut type
          - a mutable reference (that hasn't been borrowed) is the only way to access the value it points to, so is not Copy.
              
          - creating:
              - if any reference exists to the value you want to mut ref, compile error
              - as soon as you create mutable reference to a value, you cannot create any other reference to that value
                (it is impossible) until that mutable reference falls out of scope (dropped?)
              - scope can allow the latter to actually occur, but it is still safe, this is because of a compiler logic
                called `Non-Lexical Lifetimes `, that is, the ability to tell that a reference is no longer being
                used at a point before the end of the scope
              - or in other words: reference’s scope starts from where it is introduced and continues
                through the last time that reference is used.
      """,
      creationDate: dateFormatter.date(from: "1/1/2019 7:00PM")!,
      lastEditDate: dateFormatter.date(from: "1/1/2019 7:15PM")!
    )
  ]
)

let mockFolders: [Folder] = [mockFolder, mockFolderB, mockFolderC]
let mockFoldersV2: [Folder] = [mockFolderA, mockFolderE, mockFolderF]


let mockFoldersBig = (0...50).map { int -> Folder in
    .init(
      id: .init(),
      variant: .user,
      name: "F\(int)",
      notes: .init(uniqueElements: (0...int).map({ int2 -> Note in
          .init(
            id: .init(),
            title: "F\(int)-N\(int2)",
            body: "Reporting in from F\(int)-N\(int2)"
          )
      }))
    )
}
