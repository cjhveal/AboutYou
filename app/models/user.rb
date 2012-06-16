class User < ActiveRecord::Base
  attr_accessible :auth_token, :date_of_birth, :email, :name, :uid, :website

  has_many :employers
  has_many :educations

  def self.create_or_find_user token
    graph  = Koala::Facebook::API.new(token).get_object("me")
    user = User.find_or_create_by_uid graph["id"]

    user.uid = graph["id"]
    user.email = graph["email"]
    user.name = graph["name"]
    user.website = graph["website"]
    user.save

    graph["work"].each do |employer|
      puts employer
      attrs = Hash.new

      attrs["name"] = employer["employer"]["name"]
      attrs["fbid"] =  employer["employer"]["id"]
      attrs["location"] = employer["location"]["name"] unless employer["location"].blank?
      attrs["position"] = employer["position"]["name"] unless employer["position"].blank?
      attrs["start_date"] = employer["start_date"]
      attrs["end_date"] = employer["end_date"]
      attrs["user_id"] = user.id
      Employer.where(attrs).first_or_create
    end

    graph["education"].each do |education|
      puts education
      attrs = Hash.new

      attrs["name"] = education["school"]["name"]
      attrs["fbid"] = education["school"]["id"]
      attrs["year"] = education["year"]["name"]
      attrs["school_type"] = education["type"]

      if education["concentration"]
        attrs["concentration"] = education["concentration"].map {|conc| conc["name"]}.join ", "
      end
      Education.where(attrs).first_or_create
    end

    user
  end

  def create_about_me
    name = name
    hometown = nil
    location = nil
    currentWork = nil
    pastWork = "CTMS Engineering, Inc"
    education = "University of Waterloo"
    email = email
    website = website

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
      workMessage = "Currently I'm working at "+currentWork
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
