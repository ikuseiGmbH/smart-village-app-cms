class EventsController < ApplicationController
  before_action :verify_current_user
  before_action :init_graphql_client

  def index
    results = @smart_village.query <<~GRAPHQL
    query {
      eventRecords {
        id
        title
        updatedAt
        createdAt
      }
    }
    GRAPHQL

    @events = results.data.event_records
  end

  def edit
    results = @smart_village.query <<~GRAPHQL
    query {
      eventRecord(id: #{params[:id]}) {
        id
        title
        category {
          name
        }
        parentId
        regionId
        description
        contacts {
          email
          fax
          lastName
          firstName
          phone
          webUrls{
            url
            description
          }
        }
        dates {
          weekday
          dateStart
          dateEnd
          timeStart
          timeEnd
          timeDescription
          useOnlyTimeDescription
        }
        priceInformations {
          name
          amount
          groupPrice
          ageFrom
          ageTo
          minAdultCount
          maxAdultCount
          minChildrenCount
          maxChildrenCount
          description
          category
        }
        organizer {
          name
          contact {
            firstName
            lastName
            phone
            fax
            email
            webUrls {
              url
              description
            }
          }
          address {
            addition
            street
            zip
            city
            geoLocation {
              latitude
              longitude
            }
          }
        }
        dataProvider {
          name
          contact {
            firstName
            lastName
            phone
            fax
            email
            webUrls {
              url
              description
            }
          }
          address {
            addition
            street
            zip
            city
            geoLocation {
              latitude
              longitude
            }
          }
          logo {
            url
            description
          }
        }
        tagList
      }
    }
    GRAPHQL

    @event = results.data.event_record
  end

  def new
    @event = OpenStruct.new(
      dates: [OpenStruct.new],
      contacts: [OpenStruct.new(web_urls: [OpenStruct.new])],
      price_informations: [OpenStruct.new]
    )
  end

  def show

  end

  def create
    results = @smart_village.query <<~GRAPHQL
      mutation {
        createEventRecord(
          title: "Test"
          parentId: 1
          categoryName: "Test"
          regionName: "Regin"
          description: "Lorem ipsum dolor sit amet consectetur adipiscing"
          dates: [
            {
              weekday: "Monday"
              timeStart: "16:00"
              timeEnd: "18:00"
              timeDescription: "das Training findet jeden zweiten Montag im Monat statt"
              useOnlyTimeDescription: false
            }
          ]
          priceInformations: [
            { name: "Standardkarte", amount: 5.89, groupPrice: false, description: "Tarif gilt nicht in den Ferien" }
            {
              name: "Familienkarte"
              amount: 18
              groupPrice: true
              ageFrom: 2
              ageTo: 17
              minAdultCount: 10
              maxAdultCount: 17
              minChildrenCount: 3
              maxChildrenCount: 9
              description: "Tarif gilt nur in den Ferien."
            }
          ]
          accessibilityInformation: {
            description: "bla"
            types: "Tops"
            urls: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "eewrgr" }]
          }
          repeat: true
          repeatDuration: { startDate: "0001-12-18", endDate: "0021-07-19", everyYear: true }
          urls: [
            { url: "http://www.hoher-flaeming-naturpark.de", description: "Naturpark Hoher Fläming" }
            { url: "http://www.naturwacht.de", description: "Naturwacht Brandenburg" }
          ]
          mediaContents: [
            {
              captionText: "Qui dolore fugit rem."
              copyright: "Zane Marquardt"
              contentType: "image"
              height: 342
              width: 215
              sourceUrl: { url: "https://www.image.file", description: "main image" }
            }
            {
              captionText: "Id molestias omnis repellat."
              copyright: "Dr. Willard Klocko"
              contentType: "video"
              height: 315
              width: 607
            }
            {
              captionText: "Provident quidem sed velit."
              copyright: "Verona Lowe"
              contentType: "soundcloud-audio"
              height: 348
              width: 766
            }
          ]
          addresses: [
            {
              street: "Musterstraße"
              addition: "Bahnhof"
              zip: "10100"
              city: "Berlin"
              kind: "start"
              geoLocation: { latitude: 64.37264, longitude: 47.9347 }
            }
            { street: "Musterstraße2", addition: "Bahnhof 2", zip: "10100", city: "Berlin2", kind: "end" }
          ]
          contacts: [
            {
              firstName: "Tim"
              lastName: "Test"
              phone: "012345678"
              email: "test@test.de"
              fax: "09843729047"
              webUrls: [
                { url: "http://www.test1.de", description: "url 1" }
                { url: "http://www.test2.de", description: "url 2" }
              ]
            }
          ]
          organizer: {
            name: "McClure, Kemmer and Brown"
            address: {
              zip: "25083"
              city: "Mialand"
              street: "Abbie Manors"
              kind: "default"
              geoLocation: { latitude: 7.45018, longitude: 102.279 }
            }
            contact: {
              firstName: "Alonzo"
              lastName: "Von"
              phone: "+235 782-754-0007 x80976"
              webUrls: { url: "http://ebert.biz/teri.beahan", description: "Temporibus autem qui at." }
            }
          }
          tags: ["megaparty", "technoclassix", "underground"]
        ) {
          id
        }
      }
    GRAPHQL
    new_id = results.data.create_event_record.id
    redirect_to edit_event_path(new_id)
  end

  def update
    params[:id]
    results = @smart_village.query <<~GRAPHQL
      mutation {
        createEventRecord(
          title: "Test"
          parentId: 1
          categoryName: "Test"
          regionName: "Regin"
          description: "Lorem ipsum dolor sit amet consectetur adipiscing"
          dates: [
            {
              weekday: "Monday"
              timeStart: "16:00"
              timeEnd: "18:00"
              timeDescription: "das Training findet jeden zweiten Montag im Monat statt"
              useOnlyTimeDescription: false
            }
          ]
          priceInformations: [
            { name: "Standardkarte", amount: 5.89, groupPrice: false, description: "Tarif gilt nicht in den Ferien" }
            {
              name: "Familienkarte"
              amount: 18
              groupPrice: true
              ageFrom: 2
              ageTo: 17
              minAdultCount: 10
              maxAdultCount: 17
              minChildrenCount: 3
              maxChildrenCount: 9
              description: "Tarif gilt nur in den Ferien."
            }
          ]
          accessibilityInformation: {
            description: "bla"
            types: "Tops"
            urls: [{ url: "http://www.hoher-flaeming-naturpark.de", description: "eewrgr" }]
          }
          repeat: true
          repeatDuration: { startDate: "0001-12-18", endDate: "0021-07-19", everyYear: true }
          urls: [
            { url: "http://www.hoher-flaeming-naturpark.de", description: "Naturpark Hoher Fläming" }
            { url: "http://www.naturwacht.de", description: "Naturwacht Brandenburg" }
          ]
          mediaContents: [
            {
              captionText: "Qui dolore fugit rem."
              copyright: "Zane Marquardt"
              contentType: "image"
              height: 342
              width: 215
              sourceUrl: { url: "https://www.image.file", description: "main image" }
            }
            {
              captionText: "Id molestias omnis repellat."
              copyright: "Dr. Willard Klocko"
              contentType: "video"
              height: 315
              width: 607
            }
            {
              captionText: "Provident quidem sed velit."
              copyright: "Verona Lowe"
              contentType: "soundcloud-audio"
              height: 348
              width: 766
            }
          ]
          addresses: [
            {
              street: "Musterstraße"
              addition: "Bahnhof"
              zip: "10100"
              city: "Berlin"
              kind: "start"
              geoLocation: { latitude: 64.37264, longitude: 47.9347 }
            }
            { street: "Musterstraße2", addition: "Bahnhof 2", zip: "10100", city: "Berlin2", kind: "end" }
          ]
          contacts: [
            {
              firstName: "Tim"
              lastName: "Test"
              phone: "012345678"
              email: "test@test.de"
              fax: "09843729047"
              webUrls: [
                { url: "http://www.test1.de", description: "url 1" }
                { url: "http://www.test2.de", description: "url 2" }
              ]
            }
          ]
          organizer: {
            name: "McClure, Kemmer and Brown"
            address: {
              zip: "25083"
              city: "Mialand"
              street: "Abbie Manors"
              kind: "default"
              geoLocation: { latitude: 7.45018, longitude: 102.279 }
            }
            contact: {
              firstName: "Alonzo"
              lastName: "Von"
              phone: "+235 782-754-0007 x80976"
              webUrls: { url: "http://ebert.biz/teri.beahan", description: "Temporibus autem qui at." }
            }
          }
          tags: ["megaparty", "technoclassix", "underground"]
        ) {
          id
        }
      }
    GRAPHQL
    new_id = results.data.create_event_record.id
    redirect_to edit_event_path(new_id)
  end

  def destroy
  end
end
