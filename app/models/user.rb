class User < ActiveRecord::Base
  attr_accessible :auth_token, :date_of_birth, :email, :name, :uid, :website

  has_many :employers, :dependent => :destroy
  has_many :educations, :dependent => :destroy

  def history
    history = (employers + educations)
    history.sort_by(&:start_date).reverse
  end

  def self.create_or_find_user token
    graph  = Koala::Facebook::API.new(token).get_object("me")
    user = User.find_or_create_by_uid graph["id"]

    user.uid = graph["id"]
    user.email = graph["email"]
    user.name = graph["name"]
    user.website = graph["website"]
    user.location = graph["location"]["name"]
    user.hometown = graph["hometown"]["name"]
    user.save

    graph["work"].each do |employer|
      puts employer
      attrs = Hash.new

      attrs[:name] = employer["employer"]["name"]
      attrs[:fbid] =  employer["employer"]["id"]
      attrs[:location] = employer["location"]["name"] unless employer["location"].blank?
      attrs[:position] = employer["position"]["name"] unless employer["position"].blank?

      if employer["start_date"]
        year, month = employer["start_date"].split "-"
        attrs[:start_date] = DateTime.new year.to_i, month.to_i
      end

      if employer["end_date"]
        year, month = employer["end_date"].split "-"
        attrs[:end_date] = DateTime.new year.to_i, month.to_i
      end

      attrs[:user_id] = user.id
      Employer.where(attrs).first_or_create
    end

    graph["education"].each do |education|
      puts education
      attrs = Hash.new

      attrs[:name] = education["school"]["name"]
      attrs[:fbid] = education["school"]["id"]
      attrs[:end_date] = DateTime.parse "1-5-#{education["year"]["name"]}" if education["year"]["name"]
      attrs[:school_type] = education["type"]
      attrs[:user_id] = user.id

      if education["concentration"]
        attrs[:concentration] = education["concentration"].map {|conc| conc["name"]}.join ", "
      end
      Education.where(attrs).first_or_create
    end

    user
  end

  def create_about_me
    name = self.name
    hometown = self.hometown
    location = self.location
    currentWork = self.employers.first.name
    pastWork = nil
    education = self.educations.last.name
    email = self.email
    website = self.website

    nameMessage = "Hi, I'm " + name + ". "

    if hometown.nil?
      if location.nil?
        locationMessage = nil
      else
        locationMessage = "I'm from " + location + "."
      end
    else
      locationMessage = "I'm from " + hometown
      if location.nil?
        locationMessage = locationMessage + "."
      else
        locationMessage = locationMessage + " and I currently live in " + location + "."
      end
    end

    if currentWork.nil?
      if pastWork.nil?
        workMessage = nil
      else
        workMessage = "I have previously worked at "+pastWork + ""
      end
    else
      workMessage = "I work at "+currentWork
      if pastWork.nil?
        workMessage = workMessage + "."
      else
        workMessage = workMessage + " and I have previously worked at " + pastWork + "."
      end
    end

    if education.nil?
      educationMessage = nil
    else
      educationMessage = "I attend "+education + "."
    end

    if email.nil?
      emailMessage = nil
    else
      emailMessage = "You can contact me at "+email + "."
    end

    if website.nil?
      websiteMessage = nil
    else
      websiteMessage = "You can find out more about me by visiting my website, "+website + "."
    end

    a = [locationMessage, workMessage, educationMessage, emailMessage, websiteMessage].shuffle
    a.delete_if {|x| x.nil?}

    a.each {|x| nameMessage = nameMessage + x + " "}

    return nameMessage
  end
end
